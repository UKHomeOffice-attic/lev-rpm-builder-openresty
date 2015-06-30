#!/usr/bin/env bash


chmod a+x /etc/init.d/ngx_openresty

ln -s ../init.d/ngx_openresty /etc/rc.d/rc3.d/S99-ngx_openresty
ln -s ../init.d/ngx_openresty /etc/rc.d/rc3.d/K99-ngx_openresty

/etc/init.d/ngx_openresty start
