## Motivation

Docker-compose setup for starting  [Træfik](https://traefik.io/) as reverse-proxy, loadbalancer and SSL server with lets-encrypt certificates.

## Usage

Clone this repository `reverse-proxy`, change mail-address and domain, 
and then run `make deploy` or `docker-compose up -d` to startup the service.

```bash
git clone https://github.com/mastertos/reverse-proxy
cd reverse-proxy
# Run `sed` or edit `traefik.toml` and `docker-compose.yml` yourself
sed -i 's/letsencrypt\@example\.com/mail@my-domain.com/g' traefik.toml
sed -i 's/example\.com/my-domain.com/g' traefik.toml 
sed -i 's/traefik\.example\.com/traefik\.my-domain.com/g' docker-compose.yml
#Initial and Start the reverse proxy first time
make deploy
# Start the reverse proxy
docker-compose up -d
```


After that, you can "up" `docker-compose.yml`-files like:

```yaml
version: '2'

services:
  microbot:
    image: dontrebootme/microbot
    labels:
    - "traefik.enable=true"
    - "traefik.backend=microbot"
    - "traefik.frontend.rule=Host:microbot.example.com"
    - "traefik.docker.network=traefik"
    networks:
    - "traefik"
    restart: always
networks:
  traefik:
    external:
      name: traefik
```
and they will be served through the Træfik proxy. 

* Træfik will forward requests to `https://microbot.example.com` to the backend.
* Træfik will order SSL certificates through [letsencrypt.org](https://letsencrypt.org/)
* Træfik will balance the requests between multiple backends with the same name, which means
  additional instance created by `docker-compose scale microbot=3` will automatically be used when
  available. 
* Requests to `http://microbot.example.com` will be redirected to **https**

# Some details

* The label `traefik.frontend.rule=Host:microbot.example.com` is used by Træfik to determine which container to use for which domain.
* The option `exposedbydefault = false` tells Træfik to only include containers with the label `traefik.enable=true`.
* Since the gist-files are inside the directory `reverse-proxy`, Makefile will create a network `traefik` for the container. The part

```yaml
  networks:
    - "traefik"
```

and

```yaml
networks:
  traefik:
    external:
      name: traefik
```
of the microbot-file make sure that microbot is in the same network as Træfik.

If microbot were present in two networks, the label `traefik.docker.network=traefik` will tell Træfik which IP to use to connect to the service.

# LICENSING

All files are mostly derived from each sofware's documentation.
Treat this example as public domain (CC0). It took a while to get it
running, but the amount of work was not high enough to put it under any license.

# Contributing

If you want to help out in keeping this repository up-to-date, please create a pull request.
