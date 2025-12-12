This is the readme.md file in the Kvms folder for the Kvms-easy project.

<!-- SPDX-License-Identifier: GPL-2.0-only -->

Project brief:
--------------

The goal of this project is to leverage podman to create
virtual machines for windows, macos, android and linux to run as a
virtual container inside a linux host without the need to install a
fully fledged VM using virtualbox/parallels/....

It is also possible to run containerised applications from command
line or GUI so not the spoil the host OS with lots of installations.

It supports all processor types such as running ARM on x86 or running
x86 on ARM which is not available with other VM solutions.

Moreover, the host system can decide to share a folder amongst all
virtual environments, share it's network connexion in bridged mode
or create a host only network for local development.

The VMs are accessible in a browser, on VNC, RDP, SSH or on command line.

Typical use-cases are:
- Run windows 7, 8, 10/11 or macOS in a browser.
- Run a specific version of a compiler or apache web server.
- Run a php development environment without installing php on the host
  system.

Instructions for GUI applications:
----------------------------------

create vm with: `podman compose --file win7.yaml up`
stop it: `podman stop win7`
start it again: `podman start win7`

win7 can be replaced by any of the .yaml files, e.g. macos11 or android10

Instructions for command line tools:
------------------------------------

create vm with: `podman compose --file fedora-clang.yaml up --detach`
enter it with: `podman exec -it fedora-clang /bin/bash`
stop it: `podman stop fedora-clang`

Storage:
--------

A folder `data-disk` is used to define a runtime storage that can be accessed through 
Share link on windows desktop.

A more permanent solution would be to create a VM that acts as a samba share or nfs share
and that can be accessed from all machines. All machines could be embedded in a pod.

A folder `os-disk` is used to store all the os images, in principle, there images are
coming from the podman definition and are getting downloaded form the repositories.

An alternate solution is to share a folder in samba on the host system and make it
available on all virtual machines.

```
./create_storage.sh
```

Networking:
-----------

While bridging as a separate machine in the host connected network is the easy part, it has some
security implications. By default, a local network is being created with differing environments seeing
each other but no direct access from the internet is possible. A proxy will be used for that
purpose.

Setting up local network configuration on the host machine can be done with following script:

```
./create_network.sh
```

Syncing:
--------

A sync should take place in between the share folder and the kvms folder so
scripts can be shared with different environments. Update the `sync_Data.sh` script to change
the backup or synchronisation location.

Artefacts:
----------

- Windows starts rebooting each hour after 90 days. This is by design, you need to activate your
windows or re-install after 90 days.

- When creating a server with autorestart, no way to stop it without interrupting.
Unless stopped directive does not seem to do a gracefull stop.
Configuration is:
```
services:
  restart: unless-stopped
```

- Creating a folder inside the data disk asigns it to the linux user 166535.

- Windows RDP is not working on Win7.

- Checking health of a container is mandatory before using it in case of tool-containers.
e.g. `podman healthcheck run fedora-clang`
It will return unhealthy in case the initialisation script is not finished.

- Windows XP is not accessing shared data folder. Link is invalid as per windows.

- Samba server does require listening on port 445, as a non-root user, this is forbidden.
Change system as follows, add following line to `/etc/sysctl.conf`:
```
net.ipv4.ip_unprivileged_port_start=445
```
  Now issue the following command: `sysctl -p`

- The samba share on the host system is not working yet.

- The samba server project is not working yet.

- The android emulation is not working yet.

Credits:
--------

The samba set-up script is forked from the project:
https://github.com/axrusar/samba-shared-folder-linux-mint

Author:
-------

Yves De Billoëz
12-12-2025

License:
--------

This is the [readme.md](readme.md) file for kvms-easy project
released under GNU - GPL v2.0.

Further reading and sources:
----------------------------

Nothing would be possible without the foundation of these projects.

- https://github.com/qemus/qemu
- https://github.com/dockur/windows
- https://github.com/dockur/macos

The belofte scripts are being used to compile one of my other projects
that can be found here:

- https://sourceforge.net/projects/belofte/

_File last updated on 12/12/2025_