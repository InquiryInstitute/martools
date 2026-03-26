# What’s in the box

| Service   | Profile      | Host port | Role |
|-----------|--------------|-----------|------|
| Postgres  | *(default)*  | 55432     | Shared database for optional apps |
| Redis     | *(default)*  | 56379     | Cache / queues for future services |
| Umami     | `analytics`, `full` | 3030 | Privacy-friendly web analytics |
| Ollama    | `llm`, `full` | 11434  | Local LLM runtime |
| LiteLLM   | `llm`, `full` | 4000   | OpenAI-compatible proxy → Ollama |
| n8n       | `automation`, `full` | 5678 | Workflow automation (email hooks, webhooks, etc.) |

## Not bundled (add yourself or another compose file)

These are common in the [Mag.AI martech review](../../tools/ai-marketing-tools-magai-review.md) OSS table but are heavier or need extra setup:

- **Mautic / EspoCRM** — marketing CRM; use official images + separate compose.
- **Chatwoot** — multi-container; follow [Chatwoot self-hosted](https://www.chatwoot.com/docs/self-hosted).
- **PostHog** — product analytics; uses ClickHouse; see [PostHog self-host](https://posthog.com/docs/self-host).
- **RudderStack OSS** — event pipeline; see upstream Kubernetes/compose guides.
- **GrowthBook** — feature flags / experiments; [GrowthBook self-host](https://docs.growthbook.io/self-host).

Fork this repo and layer additional `docker-compose.*.yml` files with `docker compose -f docker-compose.yml -f docker-compose.mautic.yml up -d` as needed.
