Kishu is a simple Docker image which constantly resets permissions on the Drupal
'settings' directories that it finds in a Tokaido environment.

**DO NOT RUN KISHU IN PRODUCTION**. 
Kishu makes your Drupal settings file writeable, which is useful on local 
development environments like Tokaido, but hideously bad on production.

Kishu is very simple. It works by just constantly resetting permissions on the
settings directory for any settings.php file it finds inside the docroot. 

This seems like an inelegant solution, but ultimately we decided that it was the
best available given a few gotchas inherent to Drupal. For example, an early 
iteration used inotifywait to monitor for changes to the settings.php file 
(which happens when a Druapl site is installed), but the update of that file's
contents happens much earlier than the permissions change. 

Similarly, monitoring for permission changes isn't possible because auditd can't
run inside Docker, and inotify doesn't detect these types of changes at all.

Ultimately the forever-chmod process is lightweight, consistent, and reliable. 
It feels wrong, but this seems like the best possible solution to this unique 
Drupal problem. But if you can think of a better way, we'd love to hear about!

Kishu is named for one of the [shortest train lines in Japan](https://en.wikipedia.org/wiki/Kish%C5%AB_Railway_Line), befitting it's
tiny stature and footprint.
