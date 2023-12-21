# Simple Docker Project

## Part 1. Готовый докер

- Устанавливаем `Docker`
- Скачаем официальный docker-образ с nginx при помощи `docker pull`

   ![docker pull nginx](01/pics/01pull.png)

- Проверяем наличие образа при помощи `docker images`

   ![docker images](01/pics/02images.png)

- Запускаем docker образ при помощи `docker run -d [image_id|repository]`

   ![docker run -d nginx (repository)](01/pics/03run.png)

- Проверяем, что образ запустился через `docker ps`

   ![docker ps](01/pics/04ps.png)

- Смотрим информацию о контейнере через `docker inspect [container_id|container_name]`

   ![docker inspect serene_varahamihira (container_name) | head -20 (Ограничиваем вывод, чтобы было удобно сделать скриншот)](01/pics/05inspect.png)

- Выводим размер контейнера, список замапленных портов и ip контейнера при помощи `docker inspect [container_id|container_name]` и `grep`

   ![docker inspect serene_varahamihira (container_name) (-s || ) && (pipe) && (grep Size || Port -2 || IPAddress)](01/pics/06info.png)

- Останавливаем докер образ через `docker stop [container_id|container_name]`

   ![docker stop serene_varahamihira (container_name)](01/pics/07stop.png)
   
- Проверяем, что образ остановился через `docker ps`
   
   ![Смотрим, что запущено с помощью docker ps, а затем смотрим, какие контейнеры есть с помощью docker ps -a](01/pics/08ps.png)

- Запускаем докер с портами `80`и `443` в контейнере, замапленными на такие же порты на локальной машине, через команду run с помощью `docker run -d -p host_port:container_port [image_id|repository]`

   ![docker run -d -p 80:80 -p 443:443 nginx (repository)](01/pics/09ports.png)

- Проверяем, что в браузере по адресу `localhost:80` доступна стартовая страница `nginx`

   ![Октрываем в браузере localhost:80](01/pics/10localhost.png)

- Перезапускаем докер контейнер через `docker restart [container_id|container_name]` и проверяем, запустился ли контейнер с помощью `docker ps`
   
   ![docker restart nice_chaplygin (container_name) и docker ps](01/pics/11restart.png)

## Part 2. Операции с контейнером

- Прочитаем конфигурационный файл nginx.conf внутри докер контейнера через команду `exec`

  ![docker exec happy_borg (container_name) cat /etc/nginx/nginx.conf (command)](02/pics/01conf.png)

- Создаем на локальной машине файл `nginx.conf` и настраиваем в нем по пути `/status` отдачу страницы статуса сервера `nginx`

  ![Создалем файл nginx.conf ранее, меняем вывод и выводим файл с помощью cat](02/pics/02localnginxconf.png)

- Скопируем созданный файл `nginx.conf` внутрь докер образа через команду `docker cp` и перезапускаем `nginx` внутри докер образа через команду `exec`

  ![docker cp nginx.conf happy_borg(container_name):/etc/nginx/ И docker exec happy_borg (container_name) nginx -s reload](02/pics/03uploadandreload.png)

- Проверяем, что по адресу `localhost:80/status` отдается страничка со статусом сервера `nginx`

  ![Октрываем в браузере localhost/status](02/pics/04status.png)
- Экспортируем контейнер в файл container.tar через команду export
  ![docker export happy_borg (container_name) -o container.tar (filename)](02/pics/05export.png)

- Останавливаем контейнер, удаляем образ через `docker rmi [image_id|repository]`, не удаляя перед этим контейнеры, а потом удаляем остановленный контейнер

  ![docker stop happy_borg (container_name) И docker rmi image_id и получаем ошибку. Нужно использовать флаг -f И docker rm happy_borg (container_name) удаляем контейнер](02/pics/06deletes.png)

- Импортируем контейнер обратно через команду `import`

  ![docker import -c (Инструкция к dockerfile) 'cmd ["nginx", "-g", "daemon off;"]' -c (Инструкция к dockerfile) 'ENTRYPOINT ["/docker-entrypoint.sh"]' container.tar (filename) nginx (image name)](02/pics/07import.png)

- Запускаем импортированный контейнер

   ![docker images чтобы увидеть id образа И docker run -d -p 80:80 -p 443:443 image_id для запуска контейнера, как и предыдущего](02/pics/08run.png)

- Проверяем, что по адресу `localhost:80/status` отдается страничка со статусом сервера nginx

   ![Открываем в браузере localhost:80/status](02/pics/09localhost.png)

## Part 3. Мини веб-сервер

- Напишем мини сервер на `C` и `FastCgi`, который будет возвращать простейшую страничку с надписью `Hello World!`

   ![C файл](03/pics/01fastcgimain.png)

- Запускаем написанный мини сервер через `spawn-fcgi` на порту `8080` на `nginx`

   ![Переносим файл в запущенный контейнер, в самом контейнере скачиваем библиоткеку и spawn-fcgi, потом компилируем наш Си файл и запускаем процесс с нашим мини веб-сервером](03/pics/02run.png)

- Напишем свой `nginx.conf`, который будет проксировать все запросы с `81` порта на `127.0.0.1:8080`

   ![nginx.conf с частью server, где мы написали пункты listen и location](03/pics/03conf.png)

- Перезапускаем `nginx` после переноса в контейнер нового конфига

   ![docker cp И docker exec](03/pics/04restart.png)

- Проверяем в браузере по `localhost:81`, отдается ли написанная нами страничка

   ![Открываем в браузере localhost:81](03/pics/05localhost81.png)

- Сохраним файл `nginx.conf` (он понадобится нам позже)

## Part 4. Свой докер

- Написать свой докер образ, который собирает исходники мини сервера на `FastCgi` из [Части 3](#part-3-мини-веб-сервер), запускает его на `8080` порту, копирует внутрь образа написанный `nginx.conf` и запускает `nginx`

   ![Dockerfile](04/pics/01dockerfile.png)
   ![Bash script](04/pics/02sh.png)

- Собираем написанный докер образ через `docker build` при этом указав `имя` и `тег`

   ![docker build -t (Name and tag) burretie:1.0 (name:tag)](04/pics/03build.png)

- Проверяем через `docker images`, что все собралось корректно

   ![docker images](04/pics/04images.png)

- Запускаем собранный докер образ с маппингом `81` порта на `80` на локальной машине и маппингом папки `nginx` внутрь контейнера по адресу, где лежат конфигурационные файлы `nginx'а`

   ![docker run -p (маппинг портов) -v (подключение volmue (папки)) -d (Без вывода в консоль)](04/pics/05run.png)

- Проверяем `localhost:80`, доступна ли страничка написанного мини сервера
   
   ![Открываем в браузере localhost:80](04/pics/06localhost.png)

- Дописываем в `nginx/nginx.conf` проксирование странички `/status`, по которой надо отдавать статус сервера `nginx`

   ![Добавляем location /status](04/pics/07conf.png)

- Перезапускаем докер образ

   ![docker exec](04/pics/08restart.png)

- Проверяем `localhost:80/status`, отдается ли страничка со статусом `nginx`

   ![Смотрим вывод обеих страниц с сервера](04/pics/09localhost.png)

## Part 5. Dockle

- Просканируем образ из предыдущего задания через `dockle [image_id|repository]`

   ![Вывод dockle](05/pics/01dockle.png)

- Исправляем образ так, чтобы при проверке через dockle не было ошибок и предупреждений

   ![Вывод dockle после исправления и build нового Dockerfile. -ak Подавляет ошибки от NGINX и -i игнорирует ошибку](05/pics/02dockle.png)

## Part 6. Базовый Docker Compose

- Установим `docker-compose`
- Напишем файл `docker-compose.yml`, с помощью которого поднимаем докер контейнер из [Части 5](#part-5-dockle) и замапим `8080` порт второго контейнера на `80` порт локальной машины

   ![docker yml](06/pics/01yml.png)

- Поднимаем докер контейнер с `nginx`, который будет проксировать все запросы с `8080` порта на `81` порт первого контейнера

   ![Маппинг с контейнера five_server на six_proxy](06/pics/02conf.png)

- Остановим все запущенные контейнеры. Соберём и запустим проект с помощью команд `docker-compose build` и `docker-compose up`

   ![docker-compose build И docker-compose up](06/pics/03buildup.png)

- Проверяем `localhost:80`, отдается ли написанная нами страничка, как и ранее

   ![Смотрим localhost:80 в браузере](06/pics/04localhost.png)
