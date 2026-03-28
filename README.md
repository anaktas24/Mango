# Migrating Mango

> Relocating to Switzerland is a maze. Mango makes it a game.

Migrating Mango is a gamified platform that guides people through the process of moving to Switzerland. Complete real-life quests — permit applications, finding housing, opening a bank account — and earn XP and badges along the way.

---

## What it does

Moving to a new country involves dozens of steps across different systems, languages, and deadlines. Migrating Mango breaks this down into:

- **Quests** — structured task sequences (e.g. "Get your B permit")
- **Steps** — individual actions within each quest
- **XP & Badges** — earn rewards as you make progress
- **Personalised roadmap** — based on your situation (job, family, canton)

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Ruby on Rails 8 (API only) |
| Frontend | React + TypeScript (Vite) |
| Database | PostgreSQL |
| Auth | Devise + JWT |

---

## Status

Currently in development.

- [x] Rails API backend
- [x] JWT authentication (sign up, sign in, sign out)
- [ ] Core models (Quest, Step, Badge, UserQuest)
- [ ] Gamification logic (XP, badges)
- [ ] React frontend
- [ ] Personalised roadmap

---

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for the full setup guide.

---

## License

MIT
