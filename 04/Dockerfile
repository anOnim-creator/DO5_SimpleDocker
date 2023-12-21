FROM nginx
WORKDIR /home/
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./main.c .
COPY ./run.sh .
RUN apt update; apt install gcc libfcgi-dev spawn-fcgi -y
ENTRYPOINT [ "sh", "./run.sh" ]
