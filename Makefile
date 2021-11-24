build:
	docker system prune --all && docker volume prune
	cp ~/.zshrc ./build/.zshrc
	docker-compose up -d --build

