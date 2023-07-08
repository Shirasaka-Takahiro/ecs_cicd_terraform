FROM nginx:alpine
 
COPY ./docker/nginx/conf/onya-lab.site.conf /etc/nginx/conf.d/
ADD ./docker/nginx/conf/nginx.conf /etc/nginx/
COPY ./docker/sites/index.html /var/www/html/
 
EXPOSE 80