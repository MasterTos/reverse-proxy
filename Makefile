default: deploy

deploy:
	docker network create traefik
	docker-compose up -d
	touch acme.json
	chmod 600 acme.json

clean:
	docker-compose down
	docker network rm traefik
