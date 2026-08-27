<h1 align="center">Inception</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"/>
  <img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white" alt="Nginx"/>
  <img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux"/>
  <img src="https://img.shields.io/badge/GNU%20Make-A42E2B?style=for-the-badge&logo=gnu&logoColor=white" alt="GNU Make"/>
  <img src="https://img.shields.io/badge/Shell-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Shell"/>
</p>

<p align="center"><strong>A small WordPress hosting stack where every service runs in its own hand-built container, wired together with Docker Compose.</strong></p>

---

## 📌 Overview

Before containers, running a web app on a server meant installing its dependencies straight onto the host, where every service shared the same libraries, the same ports and the same failure modes.
A container packages one process with just the files it needs and nothing else, so services can sit side by side on one machine without stepping on each other.

Inception is the 42 project that forces you to build that arrangement by hand: three services (an Nginx reverse proxy, WordPress running on PHP-FPM, and a MariaDB database), each with its own `Dockerfile` starting from a bare Debian image, no ready-made `nginx` or `wordpress` image allowed.

The three containers talk over a private Docker network. Only Nginx is reachable from outside, on port 443 with TLS, and it forwards PHP requests to the WordPress container over FastCGI; WordPress in turn connects to MariaDB. The database files and the WordPress installation live in volumes bind-mounted to a directory on the host, so a full `docker compose down -v` and rebuild comes back with the same content. Credentials are passed in through environment variables rather than baked into the images, and each container starts its service as the foreground process so Docker can supervise and restart it.

## 🎯 Objectives

- Write the `Dockerfile` for each service from a Debian base image, installing and configuring the service by hand instead of pulling a prebuilt image.
- Connect the containers over a dedicated Docker network and publish a single entry point: Nginx on 443, TLS 1.2 / 1.3 only.
- Keep the MariaDB data and the WordPress files in volumes that survive tearing the stack down and rebuilding it.
- Pass every secret (database passwords, WordPress admin credentials) through an `.env` file and the environment, never through the image layers.
- Have each container run its service as PID 1 in the foreground, with a real init flow rather than a `tail -f`-style hack, and let Nginx wait on a MariaDB healthcheck before WordPress starts.

## 🛠️ Tech Stack

| Layer | Choice |
|---|---|
| Base image | `debian:bullseye` for all three services |
| Web server | Nginx, self-signed certificate, TLS 1.2 / 1.3 |
| Application | WordPress 6.4.3 on PHP-FPM 7.4, provisioned with WP-CLI |
| Database | MariaDB, initialised by a startup script |
| Orchestration | Docker Compose, one bridge network, two bind-mounted named volumes |
| Build | GNU Make wrapping `docker compose` |

## 🚀 Getting Started

Requires Docker and the Docker Compose plugin on a Linux host.

```bash
git clone https://github.com/acardona123/42_Inception.git
cd 42_Inception
```

1. Point the project domain at localhost by adding it to `/etc/hosts` (for example `127.0.0.1  acardona.42.fr`).
2. Fill `srcs/.env` with the database and WordPress values the stack expects:

   ```
   SQL_HOST, SQL_DATABASE, SQL_USER, SQL_USER_PASSWORD, SQL_ROOT_PASSWORD
   WP_DOMAIN_NAME, WP_SITE_TITLE, WP_ADMIN_LOGIN, WP_ADMIN_PASSWORD, WP_ADMIN_EMAIL
   WP_USER_LOGIN, WP_USER_MAIL, WP_USER_PASSWORD
   ```

   The WordPress admin login may not contain the string `admin`; the startup script rejects it.
3. Build and start everything:

   ```bash
   make          # build the images and run in the foreground
   make upd      # same, detached
   ```

`make` also creates the host volume directories under the path set by `VOLUMES_DIR` in the `Makefile`.

## 📖 Usage

Once the stack is up, the site is served at `https://<WP_DOMAIN_NAME>` (accept the self-signed certificate warning).

| Command | Effect |
|---|---|
| `make down` | stop and remove the containers |
| `make downv` | also remove the volumes |
| `make stop` / `make start` | pause and resume without rebuilding |
| `make prune` | tear everything down and clear the Docker cache |
| `make rm_dir` | remove the host volume directories |

The MariaDB container exposes 3306 and WordPress exposes 9000 only on the internal network; neither is published to the host.

## 📁 Structure

```
srcs/
├── docker-compose.yml
├── .env
└── requirements/
    ├── nginx/       Dockerfile · conf/nginx.conf
    ├── wordpress/   Dockerfile · conf/www.conf · tools/startWordpress.sh
    └── mariadb/     Dockerfile · tools/startMariadb.sh
docs/
└── docker-cheatsheet.md
documentation/
├── mariadb.md
└── nginx.md
```

## 📚 Resources

- [docs/docker-cheatsheet.md](docs/docker-cheatsheet.md): personal notes on Docker (containers, volumes, image builds) taken while working through the project.
- [documentation/mariadb.md](documentation/mariadb.md), [documentation/nginx.md](documentation/nginx.md): SQL and Nginx reference notes.
- [install.txt](install.txt): how the development VM was set up.
- [Docker documentation](https://docs.docker.com/), [Docker Compose file reference](https://docs.docker.com/compose/compose-file/)

---

<p align="center"><sub>🏫 Project from the <strong>42</strong> common core — School 42 Paris.</sub></p>
