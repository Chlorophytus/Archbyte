# =============================================================================
# Initialize keyring and user
# =============================================================================
ARG PACKAGES_LIST

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

# =============================================================================
# Cache
# =============================================================================
# Must depend on previous preparation (updates)
FROM prepare AS cache

# Copy packages list
COPY ${PACKAGES_LIST} /srv/archbyte/packages.txt

# Downloads but does not install the packages we are caching
WORKDIR /srv/archbyte
RUN pacman -Sw --noconfirm --root . $(< packages.txt)

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", "." ]
