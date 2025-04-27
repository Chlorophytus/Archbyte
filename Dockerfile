# =============================================================================
# Initialize keyring
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base AS initialize

# We only have to initialize the keyring and user
RUN pacman-key --init && \
    groupadd archbyte && \
    useradd -g archbyte archbyte

# =============================================================================
# Download then serve packages
# =============================================================================
# Must depend on previous preparation (updates)
FROM initialize AS serve

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm darkhttpd && \
    pacman -Suw --needed --cachedir /srv/archbyte --noconfirm - < /srv/archbyte/packages.txt && \
    chown -R archbyte:archbyte /srv/archbyte

# Drop privileges
USER archbyte

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", "/srv/archbyte" ]
CMD [ "--port", "8080" ]
