# Security

- **Defaults are for local development.** Do not expose Postgres, Redis, Ollama, or LiteLLM to the public internet without TLS, firewalls, and authentication.
- **Change all secrets** in `.env` before any shared or production-like use.
- **Umami** and **n8n** admin accounts: set strong passwords on first login; put a reverse proxy with HTTPS in front for anything beyond localhost.
- **LiteLLM**: enable `LITELLM_MASTER_KEY` (or proxy auth) before exposing port 4000.
- **Ollama**: without auth on the API, anyone who can reach `:11434` can run models—bind to localhost or protect the network path.

Report security issues through your organization’s usual channel for Castalia / Inquiry Institute projects.
