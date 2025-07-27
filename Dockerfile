# 1. Официальный PHP-образ
FROM php:8.3-cli

# 2. Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libpq-dev \
    libzip-dev \
    zip \
    libicu-dev \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql \
        intl \
        zip \
        opcache

# 3. Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4. Создание рабочей директории
WORKDIR /app

# 5. Копирование файлов проекта
COPY . .

# 6. Установка PHP-зависимостей
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 7. Очистка и прогрев кеша Symfony
RUN php bin/console cache:clear --env=prod

# 8. Открытие порта
EXPOSE 8000

# 9. Старт встроенного PHP-сервера
CMD ["php", "-d", "variables_order=EGPCS", "-S", "0.0.0.0:8000", "-t", "public"]
