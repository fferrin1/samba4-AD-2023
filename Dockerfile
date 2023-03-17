FROM debian:10
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install acl wget attr autoconf bind9utils bison build-essential \
  debhelper dnsutils docbook-xml docbook-xsl flex gdb libjansson-dev  \
  libacl1-dev libaio-dev libarchive-dev libattr1-dev libblkid-dev libbsd-dev \
  libcap-dev libcups2-dev libgnutls28-dev libgpgme-dev libjson-perl \
  libldap2-dev libncurses5-dev libpam0g-dev libparse-yapp-perl \
  libpopt-dev libreadline-dev nettle-dev perl perl-modules pkg-config \
  python-all-dev python-crypto python-dbg python-dev python-dnspython \
  python3-dnspython  python3-gpg python-markdown python3-markdown \
  python3-dev xsltproc zlib1g-dev liblmdb-dev lmdb-utils  libpython3-dev libdbus-1-dev python3-cryptography  python3-pyasn1 python3-iso8601 tzdata


RUN wget https://download.samba.org/pub/samba/stable/samba-4.15.0.tar.gz && \
    tar xzvf samba-4.15.0.tar.gz && \
    cd samba-4.15.0 && \
    ./configure --prefix=/usr/local/samba --enable-selftest --sysconfdir=/etc/samba --with-ldap --with-ads --with-winbind && \
    make -j4 && \
    make install

ENV PATH=/usr/local/samba/bin:/usr/local/samba/sbin:$PATH

VOLUME ["/var/lib/samba", "/etc/samba"]

ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["samba"]
