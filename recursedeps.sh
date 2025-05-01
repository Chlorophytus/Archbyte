#!/bin/bash

PACKAGELIST="/srv/archbyte/packages.txt"

while read PACKAGE; do
  echo "(ARCHBYTE) -> Getting dependencies for package: $PACKAGE"
  while read DEPENDENCY; do 
    echo "(ARCHBYTE) -> Detected dependency $DEPENDENCY in $PACKAGE"
    /usr/local/bin/checkdep.sh $DEPENDENCY
  done < <(pactree -u $PACKAGE | grep "^[^<=>]*$")
done < $PACKAGELIST
