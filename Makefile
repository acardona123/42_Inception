SOURCE_DIR	=	./srcs
VOLUMES_DIR	=	/home/acardona/data

all : up

up:
	@if ! [ -d $(VOLUMES_DIR)/wordpress/ ]; then mkdir $(VOLUMES_DIR)/wordpress/; fi
	@if ! [ -d $(VOLUMES_DIR)/mariadb/ ]; then mkdir $(VOLUMES_DIR)/mariadb/; fi
	VOLUMES_DIR=$(VOLUMES_DIR) docker compose -f $(SOURCE_DIR)/docker-compose.yml up --build

down: 
	VOLUMES_DIR=$(VOLUMES_DIR) docker compose -v -f $(SOURCE_DIR)/docker-compose.yml down

downv : down
	sudo rm -rf $(VOLUMES_DIR)/wordpress/ $(VOLUMES_DIR)/mariadb/

prune : downv
	docker system prune -fa

.PHONY: up down downv prune
