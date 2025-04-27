# Archbyte
Podman/Docker virtualization setup for caching Pacman packages in cold storage

## Operation

### Specifying what packages to autobuild

You define a `packages.txt` file with different packages that are of use.

```
base
base-devel
xfce4
xfce4-goodies
```

Defining these would auto-build `base`, `base-devel` and a few other packages.

### Building

Podman compose building packages seems broken, so do it by hand. In this case,
we will bind to an archbyte store in `/opt/raid/archbyte`.

```shell
$ podman build -v /opt/raid/archbyte:/srv/archbyte -t archbyte:latest .
```

### Running 

```shell
$ podman run -it -v /opt/raid/archbyte:/srv/archbyte -p 8080:8080 archbyte:latest
```

Should be on port 8080.
