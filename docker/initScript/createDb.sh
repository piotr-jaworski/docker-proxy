#!/bin/sh

if [ "$DB_SERVER" != "<to be defined>" ] && [ "$INIT_DB_FILE" ]; then
  echo "\nEnsure DB is created";
  echo "/docker-mysql/init/$INIT_DB_FILE";
  mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD < /docker-mysql/init/$INIT_DB_FILE;
fi
