# Martools

**Turnkey OSS baseline** for marketing-ops and AI-gateway experiments—intended to **fork** per project or cohort (e.g. Mag.AI labs). Pairs with the written stack review in the parent repo: [`tools/ai-marketing-tools-magai-review.md`](../tools/ai-marketing-tools-magai-review.md).

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

## Publish as its own repo

From the **parent monorepo** root (`martech/`), after `martools/` is committed:

```bash
git subtree split -P martools -b martools-only
git remote add martools-origin https://github.com/YOUR_ORG/martools.git
git push martools-origin martools-only:main
```

Or create an empty `martools` repo on GitHub and push only this directory’s contents (new clone + copy). Replace `YOUR_ORG` with e.g. `InquiryInstitute`.

## License

MIT — see [LICENSE](LICENSE). Third-party images remain under their respective licenses.
