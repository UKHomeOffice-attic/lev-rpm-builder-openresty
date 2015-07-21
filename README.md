# Docker Centos 6 OpenResty with Naxsi RPM Builder

This project contains a Dockerfile for a container that will build an OpenResty RPM package with Naxsi and Lua included, statically linked to CentOS 6 packages.

## Getting Started

These instructions will tell you how to use this container to build an RPM.

### Prerequisities

You'll need some form of docker that can have a volume mounted where it'll put the RPM. 

[Boot2docker](http://boot2docker.io/) works if you want to test it on your local machine. The following commands once you run boot2docker will get it up an running. It mounts the "/Users" directory in the VM, we'll use this as the output path for the RPM to get it on our hosts directory.  

```
boot2docker init 
boot2docker up 
eval "$(boot2docker shellinit)"
```

### Running

Assuming you have a docker instance to communicate with

```shell
docker build -t rpm-builder-waf . && docker run -v $(pwd):/rpmbuild rpm-builder-waf  
```

Will cause an RPM to fall out at ```$(pwd)``` named ```ngx_openresty-1.7.10.1-1.x86_64.rpm```

You can customise the RPM output directory in the container by setting the ```$RPM_OUTPUT_DIR``` environment variable.

## RPM Details

* The RPM will install to `/usr/local/openresty/`
* The RPM comes with a SystemV script
* The RPM will install example HTTPS certificate at ```/usr/local/openresty/nginx/conf/example.crt``` and ```/usr/local/openresty/nginx/conf/example.key```
* The nginx configuration file to set which servers it connects to can be found at ```/usr/local/openresty/nginx/conf/nginx.conf```

## Testing the RPM

There is bundled a [vagrant](https://www.vagrantup.com/) file that starts a CentOS 6 machine, that can be used for testing the RPM.

It has a base image for [VirtualBox](https://www.virtualbox.org/).

## Built With

* [OpenResty](http://openresty.org/) - It's very suitable for making WAF firewalls.
* [FPM](https://github.com/jordansissel/fpm) - Makes making RPMs very easy.
* [Docker](https://www.docker.com) - So we can statically link to RedHat compatible binaries even if we're not running on RedHat.
* [Naxsi](https://github.com/nbs-system/naxsi) - Framework for writing Web Application Firewalls

# Find us

##  Docker repository
[ukhomeofficedigital/lev-rpm-builder-openresty](https://registry.hub.docker.com/u/ukhomeofficedigital/lev-rpm-builder-openresty)

## GitHub
[UKHomeOffice/lev-rpm-builder-openresty](https://github.com/UKHomeOffice/lev-rpm-builder-openresty)


## Contributing

Feel free to submit pull requests and issues. If it's a particularly large PR, you may wish to discuss it in an issue first.

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/UKHomeOffice/lev-rpm-builder-openresty/blob/master/code_of_conduct.md). By participating in this project you agree to abide by its terms.

## Versioning

We use [SemVer](http://semver.org/) for the version tags available See the tags on this repository. 

## Authors

* **Billie Thompson** - *Developer* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/UKHomeOffice/lev-rpm-builder-openresty/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/UKHomeOffice/lev-rpm-builder-openresty/blob/master/LICENSE.md) file for details

## Acknowledgments

* jordansissel for writing FPM and saving my santity trying to build RPMs
* The Naxsi team for writing an awesome module
