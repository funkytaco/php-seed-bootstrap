#!/bin/sh
echo Building podman image.
podman build -t localhost/php-mvc-apache .
echo Running podman container...
podman run -v `pwd`:/opt -p 80:80 localhost/php-mvc-apache