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

FAQ:
----

- How is this project different from e.g. WAMP/LAMP or MAMP?

This project is doing much more. You are in complete control. xAMP have
their benefits, such as installation of phpMyAdmin and a lot of specific development
tools, this project can do the same as xAMP plus having all the other goodies and
features that go far beyond xAMP.

- How is this project different from dockur?

This project extends on dockur and proposes real-life examples of this.
It also supports at the same time Android/Samba and development environments.
To do the same with docker, you have to install multiple unvetted containers.
Here you are in full control.

- What is the security compared to docker?

Docker runs as root, and uses unvetted containers. Here the installation scripts
are available in source code and can be modified or inspected. Podman runs as an
application and can be disabled simply by stopping the container. A compromised
container on docker can compromise the complete system. Here, the container source
is open by default, it does not run until started and has no root priviledges.

- How is this project different from VirtualBox?

Virtualbox is heavy and needs a lot of maintenance for each environment. Virtualbox
is also limited to run on the same processor architecture in emulation only.
Virtualbox does not run command line environments.
Kvms-easy does allow to run e.g. compilers or toolsets on top of your linux. It
also allows to run ARM on x86 or x86 on ARM hosts. Kvms-easy requires much less
ressources.

- What are unique features of this project?

Can you imagine running windows 10, 7 or macOS on your linux machine in a browser?
Can you imagine running 2 different kernels or 2 different compiler environments
with zero install? Yes, kickstart files are not yet in here and iso deployments
neither, but will come in the next releases.

- I can install an NPM environment just by selecting the docker container!

You can do the same here, but you can also select your favorite distro iso or
specific container without taking a container from a non mainstream developer.
Which is more secure? Your fedora iso and installing npm package with install
script or using xyz/npmdevel container?

- What did motivate you to start this project?

After a while, any environment Linux and Windows alike get polluted by installing
packages or software. After a while, you don't remember what you have installed.
When setting up my n-th pc, I wanted to avoid to install anything but the standard
minimal install and get all additional software installed inside software silos.
The available tools like AppImage/Snap/Flatpack have their own drawbacks.
I also wanted to reduce disk space and maintenance for all my different VMs. And
last but not least, I wanted to run different versions of macOS or windows or
android without the maintenance burden. The real challenge was running android
ARM on windows boxes without going through the Android developer tools. Another
challenge was running recent macOS on more performant machines. All this while
maintaining maximum security and minimal attack surface.

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