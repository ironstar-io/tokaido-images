Base for Tokaido
=====

This image stores the base configuration that is used in most other Tokaido
images (such as PHP, Drush, etc). Mostly this image contains base utilities
that are used in every other image, or common config like users and permissions.

This repository is broken into three branches, which define the version tag:

- stable: Stable releases are production ready and have been running in our non-production environments for at least one month
- edge: Edge versions contain the latest version that is thought to be stable. Tokaido runs this version by default. 
- experimental: These are our in-development versions that probably aren't working just right. 