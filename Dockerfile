# =============================================================================
# Initialize keyring and user
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base AS initialize

# We only have to initialize the keyring and user
RUN pacman-key --init && \
    groupadd archbyte && \
    mkdir -p /srv/archbyte

# =============================================================================
# Prepare
# =============================================================================
# Must depend on our previous keyring
FROM initialize as prepare

# Update Pacman packages and install http daemon
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm darkhttpd

# Copy packages list
COPY ./packages.txt /srv/archbyte/

# Downloads but does not install the packages we are caching
# Copy package cache to here
RUN pacman -Suw --noconfirm $(< /srv/archbyte/packages.txt) --cachedir=/srv/archbyte/

# =============================================================================
# Cache
# =============================================================================
# Must depend on previous preparation (updates)
FROM prepare AS serve

# Drop
WORKDIR /srv/archbyte

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", ".", "--no-server-id", "--port", "8080" ]
