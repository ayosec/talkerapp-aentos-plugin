# Plugin generator

This script makes easier to write plugins for the [TalkerApp](https://talkerapp.com/).

# Usage

```bash
$ bundle install --binstubs
$ bin/rake EDIT_URL=https://talkerapp.com/accounts/NNNNN/plugins/NNNNN/edit 
```

The `EDIT_URL` is the URL where you can see the form to edit your plugin. You can get this URL in [Rooms](http://talkerapp.com/rooms), then *Plugins*, and finally the *edit* link of your plugin.

When the worker starts, it will ask your user and password. These data are not stored anywhere. They will be used to open the login form and authenticate you.

It uses the `rb-inotify` gem to detect changes in your snippets, you every time you save a file, it will recompile the plugin and upload it.
