FROM oraclelinux:7

LABEL description="Dockerfile for ORDS with Tomcat and APEX"
LABEL maintainer="Christian Mühlhaus <cmuehlhaus@xrsystems.de>"
LABEL version="0.1"


EXPOSE 8080

ARG INSTALL_DIR=/opt/apex-server
ARG ORDS_CONFIGDIR=$INSTALL_DIR/ords/conf
ARG BASE_TARZ=base.tar.gz

USER root
ADD $BASE_TARZ  $INSTALL_DIR/../
WORKDIR $INSTALL_DIR

##


COPY ords.sh $INSTALL_DIR/bin/


#CMD tomcat/bin/catalina.sh start 
