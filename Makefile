SOURCE_DIR	=	./srcs
VOLUMES_DIR	=	/home/acardona/data

all : up

gen_dir:
	mkdir -p $(VOLUMES_DIR)/wordpress/
	mkdir -p $(VOLUMES_DIR)/mariadb/

up: gen_dir
	VOLUMES_DIR=$(VOLUMES_DIR) docker compose -f $(SOURCE_DIR)/docker-compose.yml up --build

upd: gen_dir
	VOLUMES_DIR=$(VOLUMES_DIR) docker compose -f $(SOURCE_DIR)/docker-compose.yml up --build -d

down: 
	VOLUMES_DIR=$(VOLUMES_DIR) docker compose -f $(SOURCE_DIR)/docker-compose.yml down

downv :
	VOLUMES_DIR=$(VOLUMES_DIR) docker compose -f $(SOURCE_DIR)/docker-compose.yml down -v

downi : down
	docker rmi -f $(docker image ls -q) 2>/dev/null || true

downvi : downv downi

stop :
	docker compose -f $(SOURCE_DIR)/docker-compose.yml stop

start:
	docker compose -f $(SOURCE_DIR)/docker-compose.yml start

prune : downvi
	docker system prune -fa

rm_dir: downv
	sudo rm -rf $(VOLUMES_DIR)/wordpress/ $(VOLUMES_DIR)/mariadb/

.PHONY: gen_dir up upd down downv downi downvi stop start prune rm_dir
