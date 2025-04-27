# =============================================================================
# Initialize keyring and user
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base AS initialize

# We only have to initialize the keyring and user
RUN pacman-key --init && \
    mkdir -p /etc/archbyte

# =============================================================================
# Cache
# =============================================================================
# Must depend on previous preparation (updates)
FROM initialize AS serve

# Copy packages list
COPY ./packages.txt /etc/archbyte/

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm darkhttpd && \
    pacman -Syuw --noconfirm $(< /etc/archbyte/packages.txt) && \
    cp /var/cache/pacman/pkg/* /srv/archbyte/
# Drop
WORKDIR /srv/archbyte

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", ".", "--no-server-id", "--port", "8080" ]
