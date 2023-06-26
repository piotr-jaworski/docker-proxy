# Docker installation guide

## Issues on Linux (ex. Ubuntu)
1. file permissions between Docker containers and hosting system 

if You wish to read more about it here are some links:
https://jtreminio.com/blog/running-docker-containers-as-current-host-user/
https://www.jujens.eu/posts/en/2017/Jul/02/docker-userns-remap/

## Definitions
for simplicity<br>
`(H)` - refers to host system<br>
`(D)` - refers to docker container<br>

so for example<br>
`(H)user` - refers to hosting system user with name `user` (for example Ubuntu)<br>
`(D)user` - refers to Docker container user with name `user`

## Install Docker
### Install docker engine
following guide
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

results that is docker possible to run only as `(H)root` UID=0<br>
after logging to container all files are managed by `(D)root` UID=0<br>
this is because Docker implementation is native on Linux and both, `(H)` and `(D)` share one kernel and user UID table, (but not user names!)

on Mac and Windows Docker is packed in one more layer of virtualization so permissions should not be a problem at all<br>

We definitely don't want Docker to be able to do everything on our `(H)` system 

### set Docker to rootless mode
following guide
https://docs.docker.com/engine/security/rootless/

allows to:
- map current `(H)user` UID=1000 [*] to `(D)root` UID=0 (as inside container Docker see it)
- and map every other `(D)user` to be seen in `(H)` as UID=99999+`(D)`UID

[*] depends on linux distribution

often containers are configured to use other user internally for example
`docker-compose.yml`
```yaml
version: '3'

services:
    apache:
        image: prestashop/prestashop-git:7.2
```
produces image witch for handling requests uses `(D)www-data` with `(D)`UID=33 seen by `(H)` as UID=100032

the same apply to groups

it produces some problems as `(H)` user with UID=100032 doesn't exist

the best solution so far that I founded is:
### Fix (D) user and group for files
1. login to container 
```shell
docker compose exec apache bash
```
2. add `root` group on `(D)` to user `www-data` 
```shell
usermod -aG root www-data
```
3. make sure owner of the files is `www-data` and group is `root`
```shell
chown -R www-data ./
chgrp -R root ./
```
This allows:
- `(D)` apache to modify/delete any files created by `(H)user` but prevents to files added by `(H)root`
- `(D)` apache to create for example cache files, upload etc.[**]
- `(H)user` to create/modify/delete files created by `(D)www-data` if also they have `(D)root` group

[**] but by default it will create files with `(D)www-data` group, which on `(H)` system can cause 
some problems in case You wish to manipulate them, to mitigate this You can log in to container, 
or change their group on `(H)` system<br>
as they are cache, uploads etc. this should not be a problem at all

so using for example git, IDE with `(H)` will be possible to add, modify, delete files and won't make problems for `(D)` apache 

if You wish You could also create group on `(H)`
```shell
sudo groupadd -g 100032 docker-www-data
sudo usermod -aG docker-www-data $USER
```
to at least display their group instead of not mapped `(H)`GUI=100032 - unfortunately it doesn't allow `(H)user` to delete files owned by `(D)www-data`:`(D)www-data`


