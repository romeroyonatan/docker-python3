# uso la version de alpine porque pesa menos
FROM python:3.6-alpine

# instalo dependencias del SO
RUN apk update && \
    apk add postgresql-dev gcc musl-dev nginx supervisor linux-headers
RUN pip install uwsgi

# copiar configuracion de servicios
ADD supervisord.conf /etc/supervisord.conf
ADD uwsgi.ini /etc/uwsgi.ini

# configuro nginx
ADD nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/run/nginx /var/log/nginx /var/lib/nginx/logs \
             /var/lib/nginx/tmp
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
     && ln -sf /dev/stderr /var/log/nginx/error.log

# instalo dependencias python
ADD ./app/requirements.txt /
RUN pip install -r /requirements.txt

# remuevo paquetes innecesarios
RUN apk del postgresql-dev gcc musl-dev linux-headers

# copio codigo fuente
ADD ./app/ /app/
WORKDIR /app

EXPOSE 80 443

CMD ["/usr/bin/supervisord"]
