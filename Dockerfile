# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-full:0.9.11

# Set correct environment variables.
ENV HOME /root
ENV LOCALCATALOGURLBASE http://reposado

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y \
  python-pip \
  python-dev \
  curl

RUN git clone https://github.com/wdas/reposado.git /reposado
ADD preferences.plist /reposado/code/
ADD reposado.conf /etc/nginx/sites-enabled/reposado.conf

VOLUME ["/reposado", "/reposado/metadata", "/reposado/html" ]
EXPOSE 80

RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*