# laurantino-overlay

## usage

### local overlay

Create file `/etc/portage/repos.conf/laurantino-overlay.conf`:

```
[laurantino-overlay]
location = /usr/local/portage/laurantino-overlay
sync-type = git
sync-uri = git://github.com/laurantino/laurantino-overlay.git
```

After an `emerge --sync` you can use this overlay
