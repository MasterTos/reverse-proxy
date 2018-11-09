default: deploy

deploy:
	docker network create traefik
	touch acme.json
	chmod 600 acme.json
	docker-compose up -d

clean:
	docker-compose down
	docker network rm traefik
