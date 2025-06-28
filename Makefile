# Variables
COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/emagnani42/data

all: up

up:
	@echo "Building and starting containers..."
	@echo "Creating data directories..."
	mkdir -p $(DATA_DIR)/mysql $(DATA_DIR)/wordpress $(DATA_DIR)/hugo
#chown -R $(USER):$(USER) $(DATA_DIR)
	@echo "Starting Docker containers..."
	docker-compose -f $(COMPOSE_FILE) up --build -d

down:
	@echo "Stopping containers and removing volumes..."
	docker-compose -f $(COMPOSE_FILE) down -v

re: down up

clean: down
	@echo "Cleaning Docker system..."
	@docker system prune -af --volumes
	@docker volume prune -f
	@sudo rm -rf $(DATA_DIR)/mysql/* $(DATA_DIR)/wordpress/* $(DATA_DIR)/hugo/*
	@echo "Cleanup completed!"

getenv:
	@echo "Insert the path to copy the .env file from:"
	@read env_path; \
	if [ -f $$env_path ]; then \
		cp $$env_path srcs/.env; \
		echo ".env file copied successfully."; \
	else \
		echo "Error: .env file not found."; \
		exit 1; \
	fi

rebuild:
	@echo "Force rebuilding containers..."
	docker-compose -f $(COMPOSE_FILE) build --no-cache
	docker-compose -f $(COMPOSE_FILE) up -d

logs:
	docker-compose -f $(COMPOSE_FILE) logs -f

status:
	docker-compose -f $(COMPOSE_FILE) ps

.PHONY: all up down re clean rebuild logs status