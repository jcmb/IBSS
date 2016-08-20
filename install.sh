#! /bin/bash


if ! type realpath &> /dev/null ; then
   echo "Required realpath executable not found in $PATH" >&2
   exit 2
fi

APP_DIR=`dirname $0`
APP_DIR=`realpath $APP_DIR`
CURRENT_DIR=`realpath .`
#CURRENT_DIR=`dirname $CURRENT_DIR`
#echo $DIR $CURRENT_DIR

if [ "$APP_DIR" != "$CURRENT_DIR" ] 
then
  echo "$0 needs to be run from the current directory"
  exit 255
fi

chmod +x cgi-bin/*
chown www-data WWW/*
chown www-data cgi-bin/*

mkdir -p /var/www/html/IBSS
mkdir -p /usr/lib/cgi-bin/IBSS

chown www-data /var/www/html/IBSS
chown www-data /usr/lib/cgi-bin/IBSS

cp -a WWW/* /var/www/html/IBSS
cp -a cgi-bin/* /usr/lib/cgi-bin/IBSS

echo "System installed"