#!/bin/sh

ORDS="jre/bin/java -jar ords/ords.war"


$ORDS install simple --preserveParamFile

tomcat/bin/startup.sh
