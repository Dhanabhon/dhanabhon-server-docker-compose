# Dhanabhon Server Docker Container

- This repository forked from this [link](https://github.com/litespeedtech/ols-docker-env)

### Prerequisites
1. [Install Docker](https://www.docker.com/)
2. [Install Docker Compose](https://docs.docker.com/compose/)

## Configuration
Edit the `.env` file to update the demo site domain, default MySQL user, and password.

## Installation
Clone this repository or copy the files from this repository into a new folder:
```shell
git clone https://github.com/Dhanabhon/dhanabhon-server-compose
```
Open a terminal, `cd` to the folder in which `docker-compose.yml` is saved, and run:
```shell
docker compose up
```

Note: If you wish to run a single web server container, please see the [usage method here](https://github.com/litespeedtech/ols-dockerfiles#usage).

## Components
The docker image installs the following packages on your system:

|Component|Version|
| :-------------: | :-------------: |
|Linux|Ubuntu 22.04|
|OpenLiteSpeed|[Latest version](https://openlitespeed.org/downloads/)|
|MariaDB|[Latest version](https://hub.docker.com/_/mariadb)|
|PHP|[Latest version](http://rpms.litespeedtech.com/debian/)|
|LiteSpeed Cache|[Latest from WordPress.org](https://wordpress.org/plugins/litespeed-cache/)|
|ACME|[Latest from ACME official](https://github.com/acmesh-official/get.acme.sh)|
|WordPress|[Latest from WordPress](https://wordpress.org/download/)|
|phpMyAdmin|[Latest from dockerhub](https://hub.docker.com/r/bitnami/phpmyadmin/)|

## Data Structure
Cloned project 
```bash
├── acme
├── bin
│   └── container
├── data
│   └── db
├── logs
│   ├── access.log
│   ├── error.log
│   ├── lsrestart.log
│   └── stderr.log
├── lsws
│   ├── admin-conf
│   └── conf
├── sites
│   └── localhost
├── LICENSE
├── README.md
└── docker-compose.yml
```

  * `acme` contains all applied certificates from Lets Encrypt

  * `bin` contains multiple CLI scripts to allow you add or delete virtual hosts, install applications, upgrade, etc 

  * `data` stores the MySQL database

  * `logs` contains all of the web server logs and virtual host access logs

  * `lsws` contains all web server configuration files

  * `sites` contains the document roots (the WordPress application will install here)

## Usage
### Starting a Container
Start the container with the `up` or `start` methods:
```shell
$ docker compose up
```
You can run with daemon mode, like so:
```shell
$ docker compose up -d
```
The container is now built and running. 
### Stopping a Container
```shell
docker compose stop
```
### Removing Containers
To stop and remove all containers, use the `down` command:
```shell
docker compose down
```
### Setting the WebAdmin Password
We strongly recommend you set your personal password right away.
```shell
bash bin/webadmin.sh my_password
```
### Starting a Demo Site
After running the following command, you should be able to access the WordPress installation with the configured domain. By default the domain is http://localhost.
```shell
bash bin/demosite.sh
```
### Creating a Domain and Virtual Host
```shell
bash bin/domain.sh [-A, --add] example.com
```
> Please ignore SSL certificate warnings from the server. They happen if you haven't applied the certificate.
### Deleting a Domain and Virtual Host
```shell
bash bin/domain.sh [-D, --del] example.com
```
### Creating a Database
You can either automatically generate the user, password, and database names, or specify them. Use the following to auto generate:
```shell
bash bin/database.sh [-D, --domain] example.com
```
Use this command to specify your own names, substituting `user_name`, `my_password`, and `database_name` with your preferred values:
```shell
bash bin/database.sh [-D, --domain] example.com [-U, --user] USER_NAME [-P, --password] MY_PASS [-DB, --database] DATABASE_NAME
```
### Installing a WordPress Site
To preconfigure the `wp-config` file, run the `database.sh` script for your domain, before you use the following command to install WordPress:
```shell
./bin/appinstall.sh [-A, --app] wordpress [-D, --domain] example.com
```
### Install ACME 
We need to run the ACME installation command the **first time only**. 
With email notification:
```shell
./bin/acme.sh [-I, --install] [-E, --email] EMAIL_ADDR
```
### Applying a Let's Encrypt Certificate
Use the root domain in this command, and it will check for a certificate and automatically apply one with and without `www`:
```shell
./bin/acme.sh [-D, --domain] example.com
```
### Update Web Server
To upgrade the web server to latest stable version, run the following:
```shell
bash bin/webadmin.sh [-U, --upgrade]
```
### Apply OWASP ModSecurity
Enable OWASP `mod_secure` on the web server: 
```shell
bash bin/webadmin.sh [-M, --mod-secure] enable
```
Disable OWASP `mod_secure` on the web server: 
```shell
bash bin/webadmin.sh [-M, --mod-secure] disable
```
>Please ignore ModSecurity warnings from the server. They happen if some of the rules are not supported by the server.
### Accessing the Database
After installation, you can use phpMyAdmin to access the database by visiting `http://127.0.0.1:8080` or `https://127.0.0.1:8443`. The default username is `root`, and the password is the same as the one you supplied in the `.env` file.

## Customization
If you want to customize the image by adding some packages, e.g. `lsphp80-pspell`, just extend it with a Dockerfile. 
1. We can create a `custom` folder and a `custom/Dockerfile` file under the main project. 
2. Add the following example code to `Dockerfile` under the custom folder
```
FROM litespeedtech/openlitespeed:latest
RUN apt-get update && apt-get install lsphp80-pspell -y
```
3. Add `build: ./custom` line under the "image: litespeedtech" of docker-composefile. So it will looks like this 
```
  litespeed:
    image: litespeedtech/openlitespeed:${OLS_VERSION}-${PHP_VERSION}
    build: ./custom
```
4. Build and start it with command:
```shell
docker compose up --build
```

## Increase upload size in PHP.ini
Run a command in a running container
```shell
$ docker exec -it [openlitespeed container ID] /bin/bash -c "export TERM=xterm; exec bash"
```
Example
```shell
$ docker exec -it 24c8528f4619 /bin/bash -c "export TERM=xterm; exec bash"
```
If the above command doesn't work try this:
```
$ docker exec -it 24c8528f4619 /bin/bash
$ apt-get update
$ apt-get install nano
$ export TERM=xterm
```
Go to php.ini file
```shell
$ cd /usr/local/lsws/lsphp80/etc/php/8.0/litespeed/
```
Update php.ini file
```shell
$ nano php.ini
```
Edit Memory Limit & Upload Max File Size & Post Max Size & Whatever you want
```
memory_limit = 256M

upload_max_filesize = 1024M

post_max_size = 1024M
```
Exit from container
```shell
$ exit
```
Restart docker container
```shell
$ docker restart [openlitespeed container ID]
```

## References
- [OpenLiteSpeed WordPress Docker Container](https://github.com/litespeedtech/ols-docker-env)