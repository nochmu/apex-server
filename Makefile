S 			= src
T 			= dist
DOWNLOADS   = downloads

####

TOMCAT_TARZ = $(DOWNLOADS)/apache-tomcat-8.5.23.tar.gz
ORDS_ZIP    = $(DOWNLOADS)/ords.17.3.0.271.04.17.zip
JRE_TARZ    = $(DOWNLOADS)/jre-8u152-linux-x64.tar.gz
APEX_ZIP    = $(DOWNLOADS)/apex_5.1.3.zip

##

PREFIX = /opt
HOME = apex-server
ORDS_CONFIGDIR_REL = ords/conf
ORDS_CONFIGDIR = $(PREFIX)/$(HOME)/$(ORDS_CONFIGDIR_REL)

JRE_HOME = $(PREFIX)/$(HOME)/jre/

#####

BASE_TARZ = base.tar.gz

#

.PHONY: clean all image test


test : image
	docker run \
	   -it \
	   --rm=true \
	   -p 8080:18080 \
 	   -e DB_HOST=oradev \
 	   -e DB_PORT=1521 \
 	   -e DB_SERVICE=test.loc \
 	   -e DB_SYS_USER=SYS \
 	   -e DB_SYS_PW=dbchef \
 	   apex-server

###

image : $(T)/docker
	docker build \
		-t apex-server \
		--build-arg=INSTALL_DIR="$(PREFIX)/$(HOME)"   \
		--build-arg=ORDS_CONFIGDIR="$(ORDS_CONFIGDIR)" \
		--build-arg=BASE_TARZ="$(BASE_TARZ)"   \
		$(T)/docker



DOCKER_DIR = Dockerfile $(BASE_TARZ) ords.sh tomcat

$(T)/docker : $(addprefix $(T)/docker/,$(DOCKER_DIR))


$(T)/docker/ :
	mkdir -p $(T)/docker

$(T)/docker/Dockerfile: $(S)/docker/Dockerfile  $(T)/docker/
	cp  $< $@

$(T)/docker/ords.sh: $(S)/misc/ords.sh   $(T)/docker/
	cp  $< $@

$(T)/docker/tomcat:
	cp -R $(S)/tomcat $(T)/docker


$(T)/docker/$(BASE_TARZ): $(T)/$(BASE_TARZ)  $(T)/docker/
	cp  $< $@


####


$(T)/$(BASE_TARZ) : $(T)/jre $(T)/tomcat $(T)/ords $(T)/apex
	tar -cf $@ --owner=0 --group=root  --transform 's|^$(T)|$(HOME)|'  $^


$(T)/apex : $(APEX_ZIP)
	unzip $< 'apex/images/*' -d $(T)


$(T)/ords : $(ORDS_ZIP) $(T)/jre
	mkdir -p $@
	unzip $(ORDS_ZIP) -d $@
	mkdir -p $(T)/$(ORDS_CONFIGDIR_REL)
	$(T)/jre/bin/java -jar $@/ords.war configdir $(ORDS_CONFIGDIR)
	rm -r $@/{docs,examples,readme.html}
	$(S)/misc/cfg_gen.sh ords_params.properties > $@/params/ords_params.properties
	touch $@


$(T)/tomcat : $(TOMCAT_TARZ)
	mkdir -p $@
	tar -xzf  $(TOMCAT_TARZ) --strip 1 -C $@
	ln -s ../../ords/ords.war $@/webapps/ords.war
	ln -s ../../apex/images $@/webapps/i
	echo 'JRE_HOME=$(JRE_HOME)' >> $@/bin/setenv.sh
	rm $@/bin/*.{bat,tar.gz}
	rm -r $@/webapps/{docs,examples,host-manager,manager,ROOT}
	chmod +x $@/bin/*.sh
	touch $@


$(T)/jre : $(JRE_TARZ)
	mkdir -p $@
	tar -xzf $(JRE_TARZ) --strip 1 -C $@
	touch $@


clean :
	rm -rf $(T)

