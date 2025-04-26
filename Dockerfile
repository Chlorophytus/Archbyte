# =============================================================================
# Initialize keyring and user
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base AS initialize

# We only have to initialize the keyring and user
RUN pacman-key --init && \
    groupadd archbyte && \
    useradd -g archbyte archbyte

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

# Downloads but does not install the packages we are caching
RUN cd /opt/archbyte && ls -alh . && pacman -Sw - --noconfirm --root . < packages.txt

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", "." ]
