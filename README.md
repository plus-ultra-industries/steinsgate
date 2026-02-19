# Steinsgate

Steins is an AI QA copilot SaaS (Elixir + React).

## Current status
MVP backend/frontend slice is in place:
- Elixir backend with Plug/Cowboy endpoint
- React frontend bootstrapped from `priv/static/app.js`
- Project onboarding (create/list projects)
- QA run trigger endpoint with generated findings
- Markdown report export endpoint

## Run locally
Prerequisites:
- Elixir 1.16+
- Erlang/OTP 26+

```bash
mix setup
mix run --no-halt
```

Open: http://localhost:4000

## Endpoints
- `GET /health` -> `ok`
- `GET /` -> React app shell
- `GET /inertia` -> initial page payload format
- `POST /api/projects` -> project create stub

## Next build steps
1. Add real project/run schemas and persistence (Postgres + Ecto).
2. Implement Inertia protocol adapter and page routing.
3. Build project list + run trigger UI.
4. Add browser-check worker integration.
