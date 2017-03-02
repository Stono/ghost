#!/bin/bash
set -e

if [ ! -f "$GHOST_CONFIG" ]; then
  echo Error: No config found at "$GHOST_CONFIG"!  Using default
  cp /usr/local/etc/ghost/config.js.default $GHOST_CONFIG
fi

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
su -c 'npm start --production' www-data
