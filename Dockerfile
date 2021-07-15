FROM amd64/ubuntu:18.04
ENV TZ=Asia/Kolkata
ARG DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update \
	&& apt-get install -y software-properties-common \
	&& add-apt-repository ppa:ondrej/php \
	&& apt-get update \
	&& apt-get install -y php7.0 \
	&& apt-get install -y apache2 \
	&& apt-get install -y libmcrypt-dev \
	&& apt-get install -y php7.0-mcrypt \
	&& apt-get install -y php7.0-mysql \
	&& apt-get install -y php7.0-pdo \
	&& apt-get install -y php7.0-mbstring \
	&& apt-get install -y php7.0-opcache \
	&& apt-get install -y libxml2-dev \
	&& apt-get install -y php7.0-soap \
	&& apt-get install -y php7.0-fpm \
	&& apt-get install -y libapache2-mod-fcgid \
	&& apt-get install -y curl
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN a2dismod php7.0 \
	&& a2dismod mpm_prefork \
	&& a2enmod mpm_event \
	&& a2enmod proxy_fcgi setenvif \
	&& a2enconf php7.0-fpm \
	&& a2enmod proxy \
	&& a2enmod rewrite headers
COPY . /var/www/html
RUN chmod -R 777 /var/www/html \
	&& chown -R www-data:www-data /var/www/html \
	&& chmod -R g+w /var/www/html/
RUN service apache2 start
RUN service php7.0-fpm start