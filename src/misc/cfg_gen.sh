#!/bin/bash

DB_HOST=oradev
DB_PORT=1521
DB_SERVICE=test.loc
DB_SYS_USER=SYS
DB_SYS_PW=dbchef


function gen_ords_params_props {
	echo "db.hostname=$DB_HOST"
	echo "db.port=$DB_PORT"
	echo "db.servicename=$DB_SERVICE"
	echo "db.username=APEX_PUBLIC_USER"
	echo "db.password=apex"
	echo "schema.tablespace.default=SYSAUX"
	echo "schema.tablespace.temp=TEMP"
	echo "user.tablespace.default=USERS"
	echo "user.tablespace.temp=TEMP"
	echo "user.apex.listener.password=apex"
	echo "user.apex.restpublic.password=apex"
	echo "user.public.password=apex"
	echo "sys.user=$DB_SYS_USER"
	echo "sys.password=$DB_SYS_PW"
	echo "migrate.apex.rest=false"
	echo "plsql.gateway.add=true"
	echo "rest.services.apex.add=true"
	echo "rest.services.ords.add=true"
	echo "standalone.mode=false"
	echo "security.verifySSL=false"
	echo "#standalone.http.port=8080"
	echo "#standalone.mode=false"
	echo "#standalone.static.images=/opt/apex/images"
}

function gen_sys_login.sql {
#	echo "define _EDITOR = 'nano'";
	echo "CONNECT ${DB_SYS_USER}/${DB_SYS_PW}@${DB_HOST}:${DB_PORT}/${DB_SERVICE} as SYSDBA";
}

function help {
	echo "usage: cfg_gen.sh <file>"
	echo "  files:"
	echo "     ords_params.properties - ORDS param file "
	echo "     sys_login.sql          - login as SYSDBA "
}

case $1 in
	"ords_params.properties" ) gen_ords_params_props ;;
	"login.sql" ) gen_login.sql ;;
	*) help ;;
esac



