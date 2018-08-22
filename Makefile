default: deploy

deploy:
	docker network create traefik
	docker-compose up -d

clean:
	docker-compose down
	docker network rm traefik
