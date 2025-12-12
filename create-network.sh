#!/bin/bash

LOCALNET=192.168.192
VLANID=0
LOCALNETID=kvms_hostonly

if [ $# -gt 0 ] && [ $1 == "--help" ]; then
  echo Create podman/docker network
  exit 0
fi

# creating a host only network, inside a vlan

podman network exists ${LOCALNETID}
if [ $? -eq 0 ]; then
  echo Network ${LOCALNETID} already exists
else
  podman network create \
    --subnet ${LOCALNET}.0/24 --gateway ${LOCALNET}.1 --ip-range ${LOCALNET}.20-${LOCALNET}.199 \
    --opt vlan=${VLANID} \
    ${LOCALNETID}
fi

# creating a virtual network to use as independent machine
