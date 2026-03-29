# Migrating Mango

Gamified platform helping people relocate to Switzerland. Complete quests (permit, housing, banking etc.) and earn XP and badges.

**Stack:** Rails 8 API · React + TypeScript (Vite) · PostgreSQL · Devise + JWT

---

## Backend Setup (Rails 8 API)

### Prerequisites
- Ruby 3.3.6 via rbenv
- PostgreSQL
- Node.js (for frontend later)

### 1. Install latest Rails
```bash
rbenv local 3.3.6
gem install rails
```

### 2. Create the Rails API app
```bash
rails new backend --api --database=postgresql -T
```
- `--api` — API-only mode (no views)
- `--database=postgresql` — use PostgreSQL
- `-T` — skip Minitest

### 3. Configure the database
In `backend/config/database.yml`, set under `default:`:
```yaml
username: <your_os_username>
```
Remove any `host: localhost` lines to use Unix socket auth (no password needed on Linux/WSL2).

Rename the databases:
```yaml
development:
  database: mango_development

test:
  database: mango_test
```

### 4. Create the databases
```bash
bundle exec rails db:create
```

### 5. Add gems
In `Gemfile`, add:
```ruby
gem "devise"
gem "devise-jwt"
gem "rack-cors"
```
Then:
```bash
bundle install
```

### 6. Install Devise & generate User model
```bash
bundle exec rails generate devise:install
bundle exec rails generate devise User
bundle exec rails db:migrate
```

### 7. Configure Devise for API mode
In `config/initializers/devise.rb`:
- Set `config.navigational_formats = []` (no HTML redirects)
- Add JWT config block:
```ruby
config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.devise_jwt_secret_key
  jwt.dispatch_requests = [['POST', %r{^/api/v1/users/sign_in$}]]
  jwt.revocation_requests = [['DELETE', %r{^/api/v1/users/sign_out$}]]
  jwt.expiration_time = 24.hours.to_i
end
```

### 8. Generate JWT secret and store it
```bash
bundle exec rails secret
bundle exec rails credentials:edit
```
Add to the credentials file:
```yaml
devise_jwt_secret_key: <output from rails secret>
```

### 9. Add JTI column to users (token revocation)
```bash
bundle exec rails generate migration AddJtiToUsers jti:string:index:unique
bundle exec rails db:migrate
```

### 10. Update User model
In `app/models/user.rb`:
```ruby
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
```

### 11. Configure CORS
In `config/initializers/cors.rb`:
```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173"
    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ["Authorization"]
  end
end
```

### 12. Configure session middleware (required by Devise)
In `config/application.rb`, inside the `Application` class:
```ruby
config.middleware.use ActionDispatch::Cookies
config.middleware.use ActionDispatch::Session::CookieStore, key: "_mango_session"
```

### 13. Set up routes
In `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
        path: "",
        path_names: {
          sign_in: "users/sign_in",
          sign_out: "users/sign_out",
          registration: "users/sign_up"
        },
        controllers: {
          sessions: "api/v1/users/sessions",
          registrations: "api/v1/users/registrations"
        }
    end
  end
end
```

### 14. Create auth controllers
Create `app/controllers/api/v1/users/sessions_controller.rb` and `registrations_controller.rb`.
All future API controllers should inherit from `Api::V1::BaseController` which calls `authenticate_user!`.

---

## Auth Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/v1/users/sign_up` | Register — returns JWT in `Authorization` header |
| POST | `/api/v1/users/sign_in` | Login — returns JWT in `Authorization` header |
| DELETE | `/api/v1/users/sign_out` | Logout — invalidates token |

### Test with curl
```bash
curl -X POST http://localhost:3000/api/v1/users/sign_up \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "test@mango.com", "password": "password123"}}' \
  -i
```

---

## WSL2 Notes
- Always run `rbenv local 3.3.6` in the project root before `rails new`
- Use Unix socket auth for PostgreSQL (remove `host: localhost` from database.yml)
- First push setup: configure SSH key in GitHub → Settings → SSH keys

---

## Git Setup
```bash
git remote add origin git@github.com:<username>/<repo>.git
git push -u origin main
```

---

---

## Core Models

### 15. Generate Quest model
```bash
rails generate model Quest title:string description:text tips:text external_url:string estimated_duration:string xp_reward:integer priority:integer canton:string difficulty:integer
```
- `difficulty` stored as integer, mapped to `easy/medium/hard` via enum in the model
- Added `null: false` on required fields, `default: 0` on `xp_reward`, `priority`, `difficulty`
- Added enum, validations, and associations in `app/models/quest.rb`

### 16. Generate QuestPrerequisite model
```bash
rails generate model QuestPrerequisite quest:references prerequisite:references
```
- Self-referential join table — both `quest_id` and `prerequisite_id` point to the `quests` table
- Fix migration: use `foreign_key: { to_table: :quests }` on the `prerequisite` reference
- Model uses `belongs_to :prerequisite, class_name: "Quest"` to resolve the self-reference

### 17. Generate Step model
```bash
rails generate model Step title:string description:text position:integer xp_reward:integer quest:references
```
- `quest:references` adds `quest_id` foreign key automatically
- Added `null: false` and `default: 0` on required fields

### 18. Generate UserQuest model
```bash
rails generate model UserQuest user:references quest:references status:integer position:integer share_token:string
```
- `status` is an enum: `not_started: 0, in_progress: 1, completed: 2`
- `position` allows users to reorder their quest list (drag and drop)
- `share_token` is unique nullable — populated when user shares, gives a read-only public link
- Add unique index inline: `t.string :share_token, index: { unique: true }`

### 19. Generate UserStep model
```bash
rails generate model UserStep user:references step:references completed:boolean completed_at:datetime
```
- `completed` defaults to `false`, not nullable
- `completed_at` is nullable — set when step is marked complete

### 20. Generate Badge model
```bash
rails generate model Badge name:string description:text icon:string trigger:string
```
- `trigger` is a string key (e.g. `"complete_first_quest"`) used by gamification logic to award badges

### 21. Generate UserBadge model
```bash
rails generate model UserBadge user:references badge:references earned_at:datetime
```
- `earned_at` is nullable — set when badge is awarded

### 22. Add XP and level to User
```bash
rails generate migration AddXpAndLevelToUsers xp:integer level:integer
rails db:migrate
```
- Both default to `0`, not nullable
- `level` is stored (not calculated on the fly) to avoid recalculating on every request

---

## Seeds

### 23. Seed the database
File: `db/seeds.rb`
- Clears all existing data before seeding (safe to re-run)
- Creates 1 test user (`test@mango.com` / `password123`)
- Creates 3 quests: Residence Permit, Open Bank Account, Find Housing
- Creates 9 steps spread across the 3 quests (with position and xp_reward)
- Creates 3 badges with trigger keys: `complete_first_step`, `complete_first_quest`, `complete_all_quests`

Run with:
```bash
rails db:seed
```

---

## Next Steps
- [x] Add seeds (sample quests, steps, badges)
- [ ] Build API controllers (quests, steps, user_quests, user_steps, badges)
- [ ] Set up React + TypeScript frontend (Vite)
- [ ] Gamification logic (XP on step/quest completion, level up, badge awarding)

---

*Updated as we build...*
