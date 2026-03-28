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

## Next Steps
- [ ] Generate core models: Quest, Step, UserQuest, Badge, UserBadge
- [ ] Add XP and gamification fields to User
- [ ] Build quest and badge endpoints
- [ ] Set up React + TypeScript frontend

---

*Updated as we build...*
