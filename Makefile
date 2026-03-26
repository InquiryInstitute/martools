.PHONY: help up down logs ps pull-model

help:
	@echo "Martools — see README.md"
	@echo "  make up          # postgres + redis"
	@echo "  make up-all      # full profile (analytics + llm + n8n)"
	@echo "  make down"
	@echo "  make pull-model  # ollama pull llama3.2 (requires llm profile up)"

up:
	docker compose up -d

down:
	docker compose --profile full --profile analytics --profile llm --profile automation down

ps:
	docker compose ps -a

logs:
	docker compose logs -f

up-all:
	docker compose --profile full up -d

pull-model:
	docker compose --profile llm exec ollama ollama pull llama3.2
