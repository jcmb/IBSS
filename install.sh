#! /bin/bash


if ! type realpath &> /dev/null ; then
   echo "Required realpath executable not found in $PATH" >&2
   exit 2
fi

APP_DIR=`dirname $0`
APP_DIR=`realpath $APP_DIR`
CURRENT_DIR=`realpath .`
#CURRENT_DIR=`dirname $CURRENT_DIR`
echo $DIR $CURRENT_DIR

if [ "$APP_DIR" != "$CURRENT_DIR" ] 
then
  echo "$0 needs to be run from the current directory"
  exit 255
fi

chmod +x cgi-bin/*
chown www-data var/www/*
chown www-data cgi-bin/*

cp -a WWW /var/www
cp -a cgi-bin /usr/lib/cgi-bin
