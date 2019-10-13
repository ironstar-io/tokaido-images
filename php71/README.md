PHP for Tokaido
=====

This container 


Each major PHP version has several sub-versions inside Tokaido, for example
PHP 7.1 has the following releases available:

- php71-base: Contains a standard PHP 7.1 image
- - php71-fpm: Adds FPM to the PHP 7.1 image
- - - php71-fpm-xdebug: Adds Xdebug to the FPM image
- - php71-xdebug: Adds Xdebug to the base image (but doesn't include FPM)


Each image is further tagged using one of three versions:

- stable: Stable releases have been running in non-production and Tokaido environments for at least one month
- edge: Edge versions contain the latest version that is thought to be stable. 
- experimental: These are our in-development versions that probably aren't working just right. 