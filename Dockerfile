# Must depend on Arch Linux
FROM archlinux:base

# Total update of Arch Linux then installs a httpd
# Add user, change perms for serving
RUN pacman-key --init && \
    pacman -Syu --noconfirm darkhttpd && \
    groupadd archbyte && \
    useradd -m -g archbyte archbyte && \
    chown archbyte:archbyte /srv/archbyte

# Switch to this user
USER archbyte

# Go into archbyte cache directory
WORKDIR /srv/archbyte

# Downloads but does not install the packages we are caching
RUN pacman -Sw - --noconfirm --root . < packages.txt

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", "." ]
