FROM tiangolo/uwsgi-nginx-flask:python2.7-alpine3.7

# Set correct environment variables.
ENV LOCALCATALOGURLBASE http://reposado

ADD https://api.github.com/repos/wdas/reposado/git/refs/heads/master /tmp/reposado-version.json
RUN apk --no-cache --virtual build-deps add git \
	&& apk --no-cache add curl
RUN git clone https://github.com/wdas/reposado.git /reposado
ADD preferences.plist /reposado/code/
ADD reposado.conf /etc/nginx/conf.d/reposado.conf
ADD https://api.github.com/repos/jessepeterson/margarita/git/refs/heads/master /tmp/margarita-version.json
RUN rm -rf /app \
	&& git clone https://github.com/jessepeterson/margarita.git /app
ADD uwsgi.ini /app/
RUN ln -s /reposado/code/reposadolib /reposado/code/preferences.plist /app

RUN rm -f /tmp/*-version.json \
	&& apk --no-cache del build-deps

VOLUME /reposado/html /reposado/metadata
EXPOSE 80 8088
