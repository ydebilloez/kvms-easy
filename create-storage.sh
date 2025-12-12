#!/bin/bash

SHAREDSTORAGE=sharedstorage
SHAREDSTORAGENAME=kvms_${SHAREDSTORAGE}
DATADISK=data-disk
SHAREDSTORLOCATION=$(podman info -f '{{ .Store.GraphRoot }}')
OSDISK=os-disk

if [ $# -gt 0 ] && [ $1 == "--help" ]; then
  echo Create shared storage ${SHAREDSTORAGE} and data disk ${DATADISK}
  exit 0
fi

if [ ! -d ~/.config/containers ]; then
  echo "Enabling user specific container configuration options"
  mkdir -p ~/.config/containers
fi

if [ ! -L "${SHAREDSTORAGE}" ] && ! [ -e "${SHAREDSTORAGE}" ]; then
  echo Creating symlink to shared storage
  ln -s ${SHAREDSTORLOCATION}/volumes/${SHAREDSTORAGENAME}/_data/ ${SHAREDSTORAGE}
fi

if [ ! -d "${OSDISK}" ]; then
  mkdir -p ${OSDISK}
fi

if [ ! -d "${DATADISK}" ]; then
  mkdir -p ${DATADISK}
fi

#mkdir -p ${DATADISK}/teststoragecreationfolder
#touch ${DATADISK}/teststoragefile

echo Volumes are stored in : ${SHAREDSTORLOCATION}

podman volume exists ${SHAREDSTORAGENAME}
if [ $? -eq 0 ]; then
  echo Volume ${SHAREDSTORAGENAME} already exists
else
  podman volume create ${SHAREDSTORAGENAME}
fi
