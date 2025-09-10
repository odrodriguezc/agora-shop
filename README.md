# README

Containerized Ruby on Rails app with PostgreSQL using Docker Compose.

---

## Ruby version

- **Ruby:** 3.4
- **Rails:** 8.x

---

## System dependencies

- **Docker** (Desktop on Windows/macOS; Engine on Linux)
- **Docker Compose v2**
- **Git**

> No local Ruby/PostgreSQL required on the host.

---

## Configuration (Docker environment — step by step)

### 1) Build and start containers
```bash
docker compose up --build
# add -d to run in background:
# docker compose up --build -d
```

### 2) Open a shell in the Rails container
```bash
docker compose exec -it web bash
```

### 3) Initialize the Rails app (first time only)
If this repository does **not** already contain a Rails app:
```bash
rails new . --database=postgresql
bundle install
```

### 4) Configure `config/database.yml`
Use environment variables (no secrets in source):
```yml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV.fetch("DB_HOST") %>
  port: <%= ENV.fetch("DB_PORT", 5432) %>
  username: <%= ENV.fetch("DB_USERNAME") %>
  password: <%= ENV.fetch("DB_PASSWORD") %>
  pool: 5

development:
  <<: *default
  database: <%= ENV.fetch("DB_NAME") %>

test:
  <<: *default
  database: <%= ENV.fetch("DB_NAME_TEST", "app_test") %>
```

### 5) Start the Rails server (if not started by Compose)
```bash
docker compose up 
```
visit http://localhost:3000

---

## Database creation
```bash
docker compose exec -it web bash
bin/rails db:create
```

---

## Database initialization
```bash
bin/rails db:migrate
bin/rails db:seed   # optional if you have seeds
```

---

## Pg Amdin
visit http://localhost:5050/browser/ and set credentials 



## How to run the test suite
We use RSpec for testing. Specs live under `spec/` and are run with `rspec`.

Run tests inside the web container:
```bash
docker compose run --rm web bundle exec rspec
```

Or open a shell, then run:
```bash
docker compose exec -it web bash
bundle exec rspec
# or
bin/rspec
```

---

## Services (job queues, cache servers, search engines, etc.)
*(empty)*

---

## Deployment instructions
*(empty)*

---

## Daily commands
```bash
# start / rebuild
docker compose up
docker compose up --build

# stop / restart
docker compose stop
docker compose restart web

# logs
docker compose logs -f web
docker compose logs -f db

# shell
docker compose exec -it web bash

# one-off rails tasks
docker compose run --rm web bin/rails db:migrate
docker compose run --rm web bin/rails about
```

---

## Windows Git configuration (avoid noisy diffs)
Ignore permission bit changes and normalize line endings when working across Windows/WSL/Linux.

```bash
# ignore chmod changes (global)
git config --global core.fileMode false

# optional: per-repo instead of global
# git config core.fileMode false
```

Line endings:
```bash
# Windows host Git
git config --global core.autocrlf true

# Linux/macOS/WSL
git config --global core.autocrlf input
```

`.gitattributes` (commit to the repo):
```
* text=auto
*.sh text eol=lf
*.rb text eol=lf
*.bat text eol=crlf
```

---

## Troubleshooting

---

## Avoiding Errors During Docker Build

If you are setting up the project for the first time and do not have a `Gemfile` or `Gemfile.lock`, you can create default versions to avoid errors during the Docker build process:

1. Create a default `Gemfile`:
   ```bash
   echo "source 'https://rubygems.org'\ngem 'rails'" > Gemfile
   ```

2. Create an empty `Gemfile.lock`:
   ```bash
   touch Gemfile.lock
   ```

These files ensure that the `COPY Gemfile Gemfile.lock /app/` step in the `Dockerfile` does not fail. Once the Rails app is initialized, these files will be replaced with the actual versions.

---

## ELK Logging (Filebeat)

This repository includes a separate, independent ELK stack (Elasticsearch + Kibana + Logstash) with Filebeat for centralized logs. It runs alongside your app using a dedicated compose file under `logging/`.

### Prerequisites
- Linux host setting required for Elasticsearch memory mapping:
  ```bash
  sudo sysctl -w vm.max_map_count=262144
  # persist by adding: vm.max_map_count=262144 to /etc/sysctl.conf
  ```

### Start the logging stack
```bash
# Build the custom Filebeat image and start the stack
docker compose -f logging/docker-compose.yml up -d --build
```

Services:
- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601

### Start your app (separately)
```bash
docker compose up -d
```

The `web` service is labeled with `co.elastic.logs/enabled: "true"` for metadata. Filebeat tails Docker logs directly from the host and ships them to Logstash.

### Verify
```bash
docker logs -f filebeat     # Filebeat running
docker logs -f logstash     # Logstash pipeline activity
curl -s localhost:9200 | jq # Elasticsearch responding
```

Then open Kibana at http://localhost:5601 and create an index pattern for `rails-dev-*` to explore logs.

### Environment naming
The logging stack injects an environment field into events via Filebeat (`env`). Default is `dev`. Override by setting `FILEBEAT_ENV` when starting the logging compose:
```bash
FILEBEAT_ENV=prod docker compose -f logging/docker-compose.yml up -d
```
Indices will be named like `rails-prod-YYYY.MM.DD`.

### Where to look (config files)
- logging/docker-compose.yml:1 — ELK + Filebeat services
- logging/filebeat/filebeat.yml:1 — Filebeat input (Docker), metadata, output to Logstash
- logging/logstash/pipeline/logstash.conf:1 — JSON parsing and indexing to Elasticsearch

### How it works (short)
- Filebeat reads `/var/lib/docker/containers/*/*.log` and adds container metadata.
- Filebeat forwards events to Logstash (`logstash:5044`).
- Logstash parses Rails JSON logs (Lograge) and writes to Elasticsearch indices per environment.
- Kibana visualizes and searches logs.

### Testing the logging stack
Run basic health checks and a connectivity test:
```bash
# 1) Check Filebeat config syntax inside the running container
docker compose -f logging/docker-compose.yml exec filebeat filebeat test config -e

# 2) Check Filebeat output connectivity (to Logstash)
docker compose -f logging/docker-compose.yml exec filebeat filebeat test output -e

# 3) Ensure Elasticsearch is healthy
curl -fsSL http://localhost:9200 | jq

# 4) Watch logs from Filebeat and Logstash for a minute
docker compose -f logging/docker-compose.yml logs -f filebeat logstash
```

Generate an app request to produce logs, then confirm in Kibana:
```bash
# Hit your Rails app endpoint to generate a log line
curl -fsSL http://localhost:3000/ >/dev/null || true

# In Kibana, create an index pattern for: rails-dev-*
# Then search for recent events and fields like http_status, controller, action, request_id.
```

### Optional: direct GELF (alternative path)
Instead of tailing Docker logs, containers can send logs directly to Logstash via the GELF driver:
```yaml
logging:
  driver: "gelf"
  options:
    gelf-address: "udp://logstash:12201"
```
This requires your app service to be on a network reachable by the logging stack.

### Production hardening (essentials)
- Enable security in Elasticsearch/Kibana/Logstash (`xpack.security.enabled=true`) and configure users/TLS.
- Increase resources (e.g., `ES_JAVA_OPTS=-Xms2g -Xmx2g`) and set container CPU/memory limits.
- Use ILM (Index Lifecycle Management) to roll over and delete old indices.
- Persist Elasticsearch data (`es_data` volume) and ensure backups.

### Troubleshooting
- No logs in Kibana:
  - Check Filebeat logs (`docker logs -f filebeat`) for permission or connection errors.
  - Confirm Logstash is listening on 5044 and Elasticsearch is healthy.
  - Ensure your Rails logs are JSON (this repo uses Lograge with Logstash formatter).
- Elasticsearch fails to start: verify `vm.max_map_count` and available RAM.
- Too many logs/noise: adjust Filebeat `drop_event` rules in `logging/filebeat/filebeat.yml`.
