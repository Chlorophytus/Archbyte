#!/bin/sh

PACKAGELIST="/srv/archbyte/packages.txt"

while read PACKAGE; do
  echo "(ARCHBYTE) -> Getting dependencies for package: $PACKAGE"
  ALLDEPS="$(pactree -u $PACKAGE | grep "^[^<=>]*$" | tr '\n' ' ')"
  /usr/local/bin/checkdep.sh $ALLDEPS
done < $PACKAGELIST
