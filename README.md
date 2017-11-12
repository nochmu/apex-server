# APEX-Server
Build scripts to create a docker image that contains all necessary things to run Oracle APEX.
However, Oracle APEX must be installed manually.

For more information: Read the Makefile


## Requirements

	Apache Tomcat:               apache-tomcat-8.5.23.tar.gz
	Oracle REST Data Services:   ords. 17.3.0.271.04.17.zip
	Oracle APEX:                 apex_5.1.3.3.zip
	Java JRE:                    jre-8u152-linux-x64.tar.gz


The requirements have to be placed in the directory /downloads

For an update of the requirements it should be enough to change the corresponding variables in the Makefile.


## Build the docker image

	make image

