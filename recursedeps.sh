#!/bin/bash

PACKAGELIST="/srv/archbyte/packages.txt"
CACHEDIR="/srv/archbyte"
ARCHITECTURE="x86_64"

check_dependency () {
  PACKAGE="$candidate-$(pacman -Si $1 | grep Version | awk '{print $3}')"
  if [ -f "$CACHEDIR/$PACKAGE-$ARCHITECTURE.pkg.tar.zst" ] || [ -f "$CACHEDIR/$PACKAGE-any.pkg.tar.zst" ]; then
    echo "(ARCHBYTE) -> Cache hit, not downloading: $PACKAGE"
  else
    echo "(ARCHBYTE) -> Cache miss, downloading: $PACKAGE"
    pacman -Suw --cachedir $CACHEDIR --noconfirm $1
  fi
}

get_dependencies () {
  while read DEPENDENCY; do 
    echo "(ARCHBYTE) -> Detected dependency $DEPENDENCY in $1"
    check_dependency $DEPENDENCY
  done < <(pactree -u $1 | grep "^[^<=>]*$")
}

while read PACKAGE; do
  echo "(ARCHBYTE) -> Getting dependencies for package: $PACKAGE"
  get_dependencies $PACKAGE
done < $PACKAGELIST
