#!/bin/bash
set -e

# Go through the patches
PATCHES="/usr/local/etc/ghost/patches/*.patch"
for patch in $PATCHES
do
  echo Applying "$patch"
  envsubst < "$patch" > /tmp/patch.patch
  patch -p0 < /tmp/patch.patch
  rm -f /tmp/patch.patch
  rm -f "$patch"
done

chown -R www-data:www-data /data
su -c 'cd $GHOST_HOME/current && knex-migrator init' www-data
su -c 'cd $GHOST_HOME/current && npm start' www-data
