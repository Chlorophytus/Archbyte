#!/bin/sh

CACHEDIR="/srv/archbyte"
ARCHITECTURE="x86_64"

for candidate in $@; do
  PACKAGE="$candidate-$(pacman -Si $candidate | grep Version | awk '{print $3}')"

  if [ -f "$CACHEDIR/$PACKAGE-$ARCHITECTURE.pkg.tar.zst" ] || [ -f "$CACHEDIR/$PACKAGE-any.pkg.tar.zst" ]; then
    echo "(ARCHBYTE) -> Cache hit, not downloading: $PACKAGE"
  else
    echo "(ARCHBYTE) -> Cache miss, downloading: $PACKAGE"
    pacman -Suw --cachedir $CACHEDIR --noconfirm $candidate 
  fi
done
