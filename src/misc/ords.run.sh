#!/bin/sh

trap "echo TRAPed signal" HUP INT QUIT TERM

ORDS_PREFIX=/opt
cd $ORDS_PREFIX/ords/apex

INST=/opt/ords/bin/install_apex.sql
CON=$DB_SYS_USER/$DB_SYS_PW@$DB_HOST:$DB_PORT/$DB_SERVICE

sqlplus64 $CON @$INST $DB_TBLS_APEX $DB_TBLS_APEX TEMP /i/


#cd $ORDS_PREFIX/ords
#java -jar ords.war install simple --preserveParamFile


#cd $ORDS_PREFIX/tomcat
#$ORDS_PREFIX/tomcat/bin/catalina.sh run

