# Dockerized Pterodactyl

This repository provides a full, production-ready Docker setup for running the Pterodactyl Panel.
It is designed for reliability, security, and straightforward deployment on any VPS or cloud platform.

You can choose whether to run the panel using its own Nginx instance or behind an external reverse proxy
such as Traefik, Nginx Proxy Manager, or Caddy. By default the container is configured to run without Nginx
(USE_NGINX=false), which is recommended for production behind a reverse proxy.

## Repository Setup

Clone the repository:

```bash
git clone https://github.com/m4tteros/dockerized-pterodactyl
cd dockerized-pterodactyl
```

## Directory Structure

```
dockerized-pterodactyl/
│
├── docker-compose.yml
├── .env.example
├── .gitignore
├── README.md
├── LICENSE
│
├── backup.sh
├── wipe.sh
│
├── panel/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── supervisord.conf
│   ├── nginx.conf
│   └── wipe.sh
│
├── mysql/
│   ├── Dockerfile
│   └── init.sql
│
└── data/
    ├── database/
    ├── redis/
    ├── logs/
    ├── var/
    └── certs/
```

## Environment Configuration

Copy the environment file template:

```bash
cp .env.example .env
```

Then edit `.env` with your preferred settings.

### Key Variables

- `MYSQL_PASSWORD`: Database password for the `pterodactyl` user.
- `MYSQL_ROOT_PASSWORD`: Root password for MariaDB.
- `APP_URL`: The full URL to access your panel (for example `https://panel.example.com`).
- `APP_TIMEZONE`: Timezone for PHP and logs (for example `UTC`).
- `USE_NGINX`: `true` to use built-in Nginx, `false` if using an external reverse proxy (default `false`).
- `TRUSTED_PROXIES`: IP or CIDR of your proxy if behind one.
- `MAIL_*`: SMTP configuration for password resets and notifications.

## Building and Running

### Without Nginx (recommended for production with reverse proxy)

```bash
USE_NGINX=false
docker-compose up -d --build
```

### With Nginx (self-contained mode)

```bash
USE_NGINX=true
docker-compose up -d --build
```

The first build may take several minutes.

## Create the First Admin User

After containers are running:

```bash
docker-compose run --rm panel php artisan p:user:make
```

Follow the prompts to create your administrator account.

## Access the Panel

Visit your configured `APP_URL` in a browser, for example:

```
https://panel.example.com
```

If you are not using HTTPS yet, use:

```
http://your-server-ip
```

## Backup and Restore

### Backup

Run the backup script to create a timestamped snapshot of your panel and database.

```bash
bash backup.sh
```

Backups are stored in `./backups/<timestamp>/`.

### Restore

To restore a database backup:

```bash
docker exec -i pterodactyl_db mysql -u root -p panel < backups/<timestamp>/panel.sql
```

You can also restore `/data` manually to bring back file-based data.

## Reset or Clean Environment

To completely reset your installation (all data and volumes will be deleted):

```bash
bash wipe.sh
```

## Maintenance

- Update images and restart:
  ```bash
  docker-compose pull
  docker-compose up -d
  ```
- View logs:
  ```bash
  docker-compose logs -f panel
  ```
- Rebuild after config changes:
  ```bash
  docker-compose down
  docker-compose up -d --build
  ```

## Security and Deployment Notes

1. Always use strong passwords for all environment variables.
2. Never commit your `.env` file to GitHub.
3. If using Cloudflare or any reverse proxy, ensure `TRUSTED_PROXIES` matches its IP range.
4. Use HTTPS in production. If using the built-in Nginx, you can bind to ports 80 and 443 for SSL certificates (via your proxy or Let's Encrypt).
5. Keep your containers updated with `docker-compose pull`.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgements

This setup is based on the official Pterodactyl Panel Docker image and the work of the Pterodactyl community.
