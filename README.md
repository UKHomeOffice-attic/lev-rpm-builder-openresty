# rpm-builder-waf

Ords RPM Builder

```shell
docker build -t rpm-builder-waf . && docker run -v $(pwd):/rpmbuild rpm-builder-waf  
```

RPMs will fall out named ```ngx_openresty-1.7.10.1-1.x86_64.rpm```
