IMAGE_CONFIG_PATH := ""
install:
	cp imageconfig.json $(IMAGE_CONFIG_PATH)/yex-dev%3latest.json

up:
	docker-compose up -d --build