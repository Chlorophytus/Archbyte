#!/bin/bash

PACKAGELIST="/srv/archbyte/packages.txt"
CACHEDIR="/srv/archbyte"
ARCHITECTURE="x86_64"

check_dependency () {
  PACKAGE="$1-$(pacman -Si $1 | grep Version | awk '{print $3}')"
  if [ -f "$CACHEDIR/$PACKAGE-$ARCHITECTURE.pkg.tar.zst" ] || [ -f "$CACHEDIR/$PACKAGE-any.pkg.tar.zst" ]; then
    echo "(ARCHBYTE) -> Cache hit, not downloading: $PACKAGE"
  else
    echo "(ARCHBYTE) -> Cache miss, downloading: $PACKAGE"
    pacman -Suw --cachedir $CACHEDIR --noconfirm $1
  fi
}

get_dependencies () {
  while read -r -u 4 dependency; do 
    echo "(ARCHBYTE) -> Detected dependency $dependency in $1"
    check_dependency $dependency
  done 4< <(pactree -u $1 | grep "^[^<=>]*$")
}

while read -r -u 3 line; do
  echo "(ARCHBYTE) -> Getting dependencies for package: $line"
  get_dependencies $line
done 3< $PACKAGELIST
