FROM debian:10

RUN apt-get update && \
    apt-get install -y libssl-dev libpcre3-dev wget build-essential zlib1g-dev \
    git

WORKDIR /src/openssl
RUN git clone https://github.com/openssl/openssl.git

WORKDIR /src/openssl/openssl
RUN git checkout OpenSSL_1_1_1-stable

WORKDIR /src

ENV NGINX_VERSION nginx-1.19.5

RUN wget http://nginx.org/download/${NGINX_VERSION}.tar.gz
RUN tar -zxvf ${NGINX_VERSION}.tar.gz

WORKDIR /src/${NGINX_VERSION}

RUN ./configure \
        --with-mail \
        --with-mail_ssl_module \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --http-log-path=/var/log/frontline-nginx/access.log \
        --error-log-path=/var/log/frontline-nginx/error.log \
        --sbin-path=/usr/local/sbin/frontline-nginx \
        --with-openssl=/src/openssl/openssl

RUN make

RUN mkdir /tmp/out
