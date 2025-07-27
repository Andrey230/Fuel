# 1. Базовый PHP-образ с нужными расширениями
FROM php:8.3-cli

# 2. Установка зависимостей
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libpq-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_pgsql zip

# 3. Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4. Создание рабочей директории
WORKDIR /app

# 5. Копирование файлов
COPY . .

# 6. Установка зависимостей (только для продакшна)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 7. Генерация кеша
RUN php bin/console cache:clear --env=prod

# 8. Открываем порт 8000 для Symfony
EXPOSE 8000

# 9. Старт команды
CMD ["php", "-d", "variables_order=EGPCS", "-S", "0.0.0.0:8000", "-t", "public"]
