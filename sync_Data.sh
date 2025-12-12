#!/bin/bash

# this script syncs this project with another location so it can be maintained
# in both locations, it is not required for the remainder of the project
# and when forking, you can leave it out. It is used for the author only

SRC_DIR=./
DEST_DIR=../Shared/Projects/provision-pods/

if [ $# -gt 0 ] && [ $1 == "--help" ]; then
  echo Sync folders ${SRC_DIR} with ${DEST_DIR}
  echo Call $0 with -n to do a dry-run
  exit 0
fi

if [[ ! -d "$SRC_DIR" ]]; then
  echo Missing Source $SRC_DIR
fi

if [[ ! -d "$DEST_DIR" ]]; then
  mkdir -p ${DEST_DIR}
fi

#bidrectional sync, from source to dest
rsync "$@" -v -au --progress --human-readable \
  --exclude="os-disk/" --exclude="data-disk/" --exclude="sharedstorage" --exclude=".git/" \
  ${SRC_DIR} ${DEST_DIR}

#bidrectional sync, from dest to source, please note we do not delete excluded files
rsync "$@" -v -au --progress --human-readable \
  --exclude="os-disk/" --exclude="data-disk/" --exclude="sharedstorage" --exclude=".git/" \
  ${DEST_DIR} ${SRC_DIR}

#
