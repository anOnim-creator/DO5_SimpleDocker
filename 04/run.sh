#!/bin/bash

gcc -o server main.c -lfcgi
service nginx start
nginx -s reload
spawn-fcgi -p 8080 -n server
