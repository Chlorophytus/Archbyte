# =============================================================================
# Initialize keyring
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base AS initialize

# We only have to initialize the keyring and user
RUN pacman-key --init && \
    mkdir -p /etc/archbyte

# =============================================================================
# Download packages
# =============================================================================
# Must depend on previous preparation (updates)
FROM initialize AS download

# Copy packages list
COPY ./packages.txt /etc/archbyte/

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm darkhttpd && \
    pacman -Syuw --noconfirm $(< /etc/archbyte/packages.txt)

# =============================================================================
# Copy and serve packages
# =============================================================================
FROM download as serve

# Copy packages
RUN mkdir /srv/archbyte && cp /var/cache/pacman/pkg/* /srv/archbyte/

# Drop
WORKDIR /srv/archbyte

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", ".", "--no-server-id", "--port", "8080" ]
