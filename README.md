# Reverse proxy with docker
## Install docker
guide for that and troubleshooting can be found
[here](docs/docker_install.md)

## Add new site to proxy
### Add container
keep in mind You will need to add at least one file into: `docker/compose`<br>
to make it easier there is example file You could easily copy
```shell
cp ./docker/compose/02_example.yml.bck ./docker/compose/02_example.yml 
```
name it as You wish please remember following pattern with first two characters in name should be a number between 02-99<br>
by this it will always generate in proper order

### Add database
it is suggested to create database for every new container You can copy example and modify it for Your needs
```shell
cp ./docker/mysql/init/00_example.sql.bck ./docker/compose/02_example.sql 
```

### After adding new site to configuration
remember to run next step

## Generate docker-compose.yml
before starting docker, You need to generate docker-compose.yml
```shell
cat docker/compose/*.yml > docker-compose.yml
```

## Running docker
Initialize containers 
```shell
docker compose up -d
```

keep in mind sql scripts `./docker/mysql/init` are run only once when `mysql` container is created

They can still be run manually by logging to container
```shell
docker compose exec example bash
```
and executing them like this:
```shell
mysql -u root -p -h mysql < /docker-mysql/init/02_example.sql
```

if You have any problems with user permission to files (common problem on Linux) check
[Docker install guide](docs/docker_install.md#fix-d-user-and-group-for-files)

