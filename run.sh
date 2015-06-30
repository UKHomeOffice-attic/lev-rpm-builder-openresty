#!/usr/bin/env bash

# Prepare
(wget -O ngx_openresty-1.7.10.1.tar.gz http://openresty.org/download/ngx_openresty-1.7.10.1.tar.gz && \
    tar xzvf ngx_openresty-1.7.10.1.tar.gz && \
    rm ngx_openresty-1.7.10.1.tar.gz) || exit 1

(wget -O luarocks-2.2.1.tar.gz http://luarocks.org/releases/luarocks-2.2.1.tar.gz && \
    tar xzvf luarocks-2.2.1.tar.gz && \
    rm luarocks-2.2.1.tar.gz) || exit 1

(wget -O naxsi.zip https://github.com/nbs-system/naxsi/archive/master.zip && \
    unzip naxsi.zip && \
    rm naxsi.zip) || exit 1

# Build!

(cd ngx_openresty-1.7.10.1 && \
    ./configure --add-module=../naxsi-master/naxsi_src && \
    make && \
    mkdir -p /tmp/installdir && \
    make install DESTDIR=/tmp/installdir && \
cd ..) || exit 1

(cd luarocks-2.2.1 && \
    ./configure --prefix=/tmp/installdir/usr/local/openresty/luajit --with-lua=/tmp/installdir/usr/local/openresty/luajit/ --lua-suffix=jit-2.1.0-alpha --with-lua-include=/tmp/installdir/usr/local/openresty/luajit/include/luajit-2.1 && \
    make build && \
    make install && \
cd ..) || exit 1

/tmp/installdir/usr/local/openresty/luajit/bin/luarocks install uuid || exit 1
/tmp/installdir/usr/local/openresty/luajit/bin/luarocks install luasocket || exit 1

(cd rpmbuild/) || exit 1

(mkdir -p /tmp/installdir/etc/init.d) || exit 1
(cp /root/rpmbuild/config/systemv.sh /tmp/installdir/etc/init.d/ngx_openresty) || exit 1
(cp /root/rpmbuild/config/example.key /tmp/installdir/usr/local/openresty/nginx/conf/example.key) || exit 1
(cp /root/rpmbuild/config/example.crt /tmp/installdir/usr/local/openresty/nginx/conf/example.crt) || exit 1
(cp /root/rpmbuild/config/nginx.conf /tmp/installdir/usr/local/openresty/nginx/conf/nginx.conf) || exit 1

(fpm -s dir -t rpm -C /tmp/installdir \
    -n ngx_openresty \
    -v 1.7.10.1 \
    --iteration 1 \
    --vendor apifactory \
    --license BSD \
    -d "pcre" \
    -d "openssl" \
    --after-install rpmbuild/postinstall.sh \
    --after-remove rpmbuild/postremove.sh \
    --config-files etc/init.d/ngx_openresty \
    --config-files usr/local/openresty/nginx/conf/example.key \
    --config-files usr/local/openresty/nginx/conf/example.crt \
    --config-files usr/local/openresty/nginx/conf/nginx.conf) || exit 1

cp *.rpm /rpmbuild || exit 1
