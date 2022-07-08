FROM composer:2.3.8 as composer_build

COPY database/ database/
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist

FROM php:8.1.7-apache
COPY . /var/www/html
RUN sed -i -e "s/html/html\/public/g" /etc/apache2/sites-enabled/000-default.conf
COPY --from=composer_build /app/vendor/ /var/www/html/vendor/
RUN chown -R www-data:www-data /var/www/html/storage