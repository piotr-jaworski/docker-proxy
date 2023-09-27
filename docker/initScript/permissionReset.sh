#!/bin/sh

echo "\nEnsure file permissions are properly set for linux";
usermod -aG root www-data
chown -R www-data ./
chgrp -R root ./
