ARG version="6.0.0"
ARG namespace="puppet"
FROM "$namespace"/puppetdb-base:"$version"

LABEL org.label-schema.maintainer="Puppet Release Team <release@puppet.com>" \
      org.label-schema.vendor="Puppet" \
      org.label-schema.url="https://github.com/puppetlabs/puppetdb" \
      org.label-schema.name="PuppetDB" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.version="$PUPPETDB_VERSION" \
      org.label-schema.vcs-url="https://github.com/puppetlabs/puppetdb" \
      org.label-schema.vcs-ref="$vcs_ref" \
      org.label-schema.build-date="$build_date" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/release.Dockerfile"

RUN wget https://apt.puppetlabs.com/puppet6-release-"$UBUNTU_CODENAME".deb && \
    dpkg -i puppet6-release-"$UBUNTU_CODENAME".deb && \
    rm puppet6-release-"$UBUNTU_CODENAME".deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppetdb="$PUPPETDB_VERSION"-1"$UBUNTU_CODENAME" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY logback.xml /etc/puppetlabs/puppetdb/logback.xml
COPY request-logging.xml /etc/puppetlabs/puppetdb/request-logging.xml
COPY conf.d /etc/puppetlabs/puppetdb/conf.d/
RUN mkdir -p /opt/puppetlabs/server/data/puppetdb/logs

# We want to use the HOCON database.conf and config.conf files, so get rid
# of the packaged files
RUN rm -f /etc/puppetlabs/puppetdb/conf.d/database.ini && \
    rm -f /etc/puppetlabs/puppetdb/conf.d/config.ini

COPY release.Dockerfile /
