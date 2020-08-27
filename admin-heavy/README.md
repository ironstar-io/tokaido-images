The Tokaido Drush Heavy container extends the standard Drush base image and 
adds useful build utilities for local development systems, such as NPM, Yarn, 
Ruby, and more. 

This container also grants the `tok` user access to run sudo commands. For this 
reason above all others, this image is not intended for use in production
environments. Use the base drush image for this, as it doesn't even ship with 
the sudo command. 