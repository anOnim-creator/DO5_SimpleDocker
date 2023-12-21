FROM nginx
WORKDIR /home/
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY main.c .
COPY run.sh .
RUN apt update; apt install gcc libfcgi-dev spawn-fcgi -y; \
    apt clean && rm -rf /var/lib/apt/lists/*; \
    chown -R nginx:nginx /etc/nginx/nginx.conf; \
    chown -R nginx:nginx /var/cache/nginx; \
    chown -R nginx:nginx /home; \
    touch /var/run/nginx.pid; \
    chown -R nginx:nginx /var/run/nginx.pid; \
    chmod a-s \
      /usr/bin/* \
      /usr/sbin/* \
      /usr/libexec/*/*
USER nginx
ENTRYPOINT [ "sh", "./run.sh" ]
HEALTHCHECK NONE