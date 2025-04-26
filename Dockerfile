# =============================================================================
# Builder
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base

# Runs a total update based on Arch Linux Docker container recommendations
# Also makes the package caching directory
RUN pacman -Syu && mkdir -p /opt/archbyte

# Go into the archbyte caching directory
WORKDIR /srv/archbyte/

# Downloads but does not install the packages we are caching
RUN pacman -Sw - --root . < ./packages.txt

# =============================================================================
# Runner
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base

# Total update of Arch Linux then installs a httpd
RUN pacman -Syu && pacman -S darkhttpd

# Add user, change perms for serving, then switch
RUN groupadd archbyte && \
    useradd -m -g archbyte archbyte && \
    chown -R /srv/archbyte
USER archbyte

# Go into archbyte cache directory
WORKDIR /srv/archbyte

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", "." ]
