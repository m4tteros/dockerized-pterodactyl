FROM ghcr.io/pterodactyl/panel:latest

USER root

ARG APP_TIMEZONE=UTC
ARG USE_NGINX=false

ENV TZ=${APP_TIMEZONE}
ENV USE_NGINX=${USE_NGINX}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        vim \
        tzdata \
        git \
        ca-certificates \
        unzip \
        supervisor && \
    if [ "$USE_NGINX" = "true" ]; then \
        apt-get install -y nginx; \
    fi && \
    rm -rf /var/lib/apt/lists/*

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

WORKDIR /app
RUN mkdir -p /app/storage/logs /app/var /run/php && \
    chown -R www-data:www-data /app

RUN php artisan config:clear || true && \
    php artisan cache:clear || true && \
    php artisan view:clear || true

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN if [ "$USE_NGINX" = "true" ]; then \
        echo "Nginx enabled"; \
    else \
        echo "Disabling Nginx config"; \
        rm -f /etc/supervisor/conf.d/supervisord.conf; \
    fi

USER www-data

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -fs http://localhost/ || exit 1

USER root
ENTRYPOINT ["/entrypoint.sh"]
