# =============================================================================
# Initialize keyring
# =============================================================================
# Must depend on Arch Linux
FROM archlinux:base AS initialize

# We only have to initialize the keyring and user
RUN pacman-key --init && \
    groupadd archbyte && \
    useradd -g archbyte archbyte

ADD ./recursedeps.sh /usr/local/bin/

# =============================================================================
# Download then serve packages
# =============================================================================
# Must depend on previous preparation (updates)
FROM initialize AS serve

# Update the system, install pactree (must be used to enumerate base packages)
# and then install the packages.txt listing
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm darkhttpd pacman-contrib && \
    /usr/local/bin/recursedeps.sh && \
    chown -R archbyte:archbyte /srv/archbyte

# Drop privileges
USER archbyte

# Serve
ENTRYPOINT [ "/usr/bin/darkhttpd", "/srv/archbyte" ]
CMD [ "--port", "8080" ]
