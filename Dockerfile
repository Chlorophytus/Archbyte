# =============================================================================
# Initialize keyring
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base AS initialize

# We only have to initialize the keyring and user
RUN pacman-key --init

# =============================================================================
# Download then serve packages
# =============================================================================
# Must depend on previous preparation (updates)
FROM initialize AS serve

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm darkhttpd && \
    pacman -Suw --noconfirm $(< /srv/archbyte/packages.txt) --cachedir /srv/archbyte

# Drop
WORKDIR /srv/archbyte

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", "." ]
