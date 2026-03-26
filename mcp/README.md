# MCP integration for Martools

Use these [Model Context Protocol](https://modelcontextprotocol.io/) servers from **Cursor**, **Claude Desktop**, or any MCP client so an LLM can query your **local** Martools stack. Start the matching Compose services first (see the repo [README](../README.md)).

## Security

- **Third-party servers** below are not maintained in this repo. Pin versions (`@modelcontextprotocol/server-postgres@0.6.2`, `npx …@1.2.3`, etc.) if you need reproducibility, and read each upstream’s security notes.
- **Secrets**: Prefer env vars in your MCP config instead of committing passwords. Never commit real API keys or DB passwords.
- **Postgres MCP** is **read-only** by design; it still exposes schema and data—use a dedicated DB user if you need stricter isolation.
- **Redis / n8n / Umami** MCP servers can **write** or change production data. Use dev instances and backups.

## Prerequisites

- [Node.js](https://nodejs.org/) (for `npx` servers)
- [uv](https://docs.astral.sh/uv/) (for `uvx` + Redis MCP), **or** use the Docker variant in [Redis MCP docs](https://github.com/redis/mcp-redis)
- Martools ports (defaults): Postgres `55432`, Redis `56379`, Umami `3030`, Ollama `11434`, LiteLLM `4000`, n8n `5678`

## One file per client

| Client | Config location (typical) |
|--------|---------------------------|
| **Cursor** | `~/.cursor/mcp.json` or project `.cursor/mcp.json` |
| **Claude Desktop** | `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) |

Copy [cursor-mcp.example.json](./cursor-mcp.example.json) and replace placeholders.

## Service → MCP mapping

| Martools service | MCP server | Purpose |
|------------------|------------|---------|
| **Postgres** | [`@modelcontextprotocol/server-postgres`](https://www.npmjs.com/package/@modelcontextprotocol/server-postgres) | Read-only SQL + schema inspection against `martools` DB |
| **Redis** | [`redis-mcp-server`](https://github.com/redis/mcp-redis) (via `uvx`) | Keys, hashes, streams, etc. |
| **Umami** | [`umami-mcp`](https://www.npmjs.com/package/umami-mcp) | Stats, sites, reports (needs Umami API token or login) |
| **Ollama** | [`ollama-mcp-server`](https://www.npmjs.com/package/ollama-mcp-server) | List/pull models, chat/completions against local Ollama |
| **LiteLLM** | *(no thin client in this bundle)* | Same models as Ollama: use **Ollama MCP** on `:11434`, or call the OpenAI-compatible API at `http://127.0.0.1:4000/v1/...` from your workflow. For proxy-native MCP features see [LiteLLM MCP docs](https://docs.litellm.ai/docs/mcp). |
| **n8n** | [`n8n-mcp`](https://www.npmjs.com/package/n8n-mcp) | Node docs + optional API control (`N8N_API_URL`, `N8N_API_KEY`) |

## Placeholders to replace

| Placeholder | Source |
|-------------|--------|
| `REPLACE_POSTGRES_PASSWORD` | Same as `POSTGRES_PASSWORD` in Martools `.env` |
| `REPLACE_UMAMI_TOKEN` | Umami → Settings → API Keys (Umami Cloud). **Self-hosted:** omit `UMAMI_TOKEN` and set `UMAMI_USERNAME` / `UMAMI_PASSWORD` instead (see [umami-mcp](https://www.npmjs.com/package/umami-mcp)). |
| `REPLACE_N8N_API_KEY` | n8n → Settings → API |

## Enable only what you run

Comment out or remove MCP entries for services you have not started. Example: skip `martools-umami` until `docker compose --profile analytics up -d`.

**n8n-mcp (documentation only):** To use node docs without attaching to the n8n API, drop `N8N_API_URL` and `N8N_API_KEY` from the `martools-n8n` block and keep `MCP_MODE`, `LOG_LEVEL`, and `DISABLE_CONSOLE_OUTPUT` as in the example.

**Umami self-hosted (password login):** Replace the `UMAMI_TOKEN` env entry with:

```json
"UMAMI_USERNAME": "admin",
"UMAMI_PASSWORD": "REPLACE_UMAMI_PASSWORD"
```

(and remove `UMAMI_TOKEN`).

## Validate

After editing config, restart the IDE or Claude. Use the client’s MCP inspector if available; for Postgres, a simple “list tables in the martools database” prompt is a good smoke test.
