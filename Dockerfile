FROM lucee/lucee:5.3

###
### Labels
###
LABEL \
	name="Robs Lucee Image" \
	image="Robs lucee53-latest" \
	build-date="2021-11-29"


###
### Installation
###

# required packages
RUN set -x \
	&& apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
		make \
		python-yaml \
		supervisor \
		wget \
		socat \
		procps \
		less nano \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get purge -y --auto-remove


# watcherd
RUN set -x \
	&& wget --no-check-certificate -O /usr/bin/watcherd https://raw.githubusercontent.com/devilbox/watcherd/master/watcherd \
	&& chmod +x /usr/bin/watcherd


RUN mkdir -p /opt/lucee/server/lucee-server/context /opt/lucee/web
RUN mkdir -p /opt/lucee/web/logs
RUN mkdir -p /opt/lucee/tomcat/
RUN rm -fr /opt/lucee/tomcat/webapps
RUN rm -fr /var/www


###
### Volumes
###
VOLUME /shared/httpd
RUN ln -sf /shared/httpd /opt/lucee/tomcat/webapps
RUN ln -sf /shared/httpd /var/www
VOLUME /usr/local/tomcat/webapps


###
### Ports
###

EXPOSE 8888 8009
COPY ./data/catalina.sh /usr/local/tomcat/bin
COPY ./data/rc.local /etc/
