# Martools

**Turnkey OSS baseline** for marketing-ops and AI-gateway experiments—intended to **fork** per project or cohort (e.g. Mag.AI labs). Pairs with the written stack review in the Castalia martech repo: [Mag.AI tools review](https://github.com/InquiryInstitute/martech/blob/main/tools/ai-marketing-tools-magai-review.md).

**Standalone repo:** [github.com/InquiryInstitute/martools](https://github.com/InquiryInstitute/martools) — this tree also lives under [`InquiryInstitute/martech`](https://github.com/InquiryInstitute/martech) as `martools/` for monorepo workflows.

This is **not** a full Mautic/Chatwoot/PostHog bundle (those are multi-service). It gives you **working Postgres + Redis** plus **optional Compose profiles** for analytics (Umami), local LLM (Ollama + LiteLLM), and automation (n8n). Extend with your own compose files.

## Quick start

1. **Fork** this repository (or copy the `martools/` tree into a new repo—see [Publish as its own repo](#publish-as-its-own-repo)).

2. **Configure secrets**

   ```bash
   cp .env.example .env
   # edit .env — set POSTGRES_PASSWORD and UMAMI_APP_SECRET (if using analytics)
   ```

3. **Core services** (always-on database + cache)

   ```bash
   docker compose up -d
   # Postgres → localhost:55432  |  Redis → localhost:56379
   ```

4. **Optional profiles**

   ```bash
   # Web analytics (Umami) → http://localhost:3030
   docker compose --profile analytics up -d

   # Ollama + LiteLLM (OpenAI-compatible proxy) → http://localhost:11434  http://localhost:4000
   docker compose --profile llm up -d
   docker compose exec ollama ollama pull llama3.2

   # Workflow automation (n8n) → http://localhost:5678
   docker compose --profile automation up -d

   # Everything above at once
   docker compose --profile full up -d
   ```

5. **First-time Umami:** open `http://localhost:3030` and create the admin user.

6. **LiteLLM:** point clients at `http://localhost:4000` using the [LiteLLM proxy API](https://docs.litellm.ai/docs/proxy/quick_start); models follow `config/litellm.yaml` (default: `llama3.2` via Ollama).

## Make targets

| Command | Effect |
|---------|--------|
| `make up` | Postgres + Redis |
| `make up-all` | `--profile full` |
| `make down` | Stops all profile combinations used here |
| `make pull-model` | `ollama pull llama3.2` (LLM profile must be running) |

## Layout

```
martools/
├── docker-compose.yml    # services + profiles
├── config/litellm.yaml   # LiteLLM → Ollama
├── docker/postgres/init/ # creates umami + n8n databases
├── docs/STACK.md         # port matrix + what to add next
├── SECURITY.md
└── .env.example
```

## Sync from the monorepo

Canonical development may happen in **`martech`** alongside [`tools/`](https://github.com/InquiryInstitute/martech/tree/main/tools). To refresh **this** repo from `martools/`:

```bash
# from martech/ repository root, after committing martools/
git subtree split -P martools -b martools-only
git push https://github.com/InquiryInstitute/martools.git martools-only:main --force-with-lease
```

Use `--force-with-lease` only when you intend to replace `main` on the standalone repo (coordinate with collaborators).

## License

MIT — see [LICENSE](LICENSE). Third-party images remain under their respective licenses.
