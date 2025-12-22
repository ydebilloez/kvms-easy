This is the readme.md file in the Kvms folder for the Kvms-easy project.

<!-- SPDX-License-Identifier: GPL-2.0-only -->

Project brief:
--------------

The goal of this project is to leverage podman to create
virtual machines for windows, macOS, android and Linux to run as a
virtual container inside a Linux host without the need to install a
fully fledged VM using virtualbox/parallels/....

It is also possible to run containerised applications from command
line or GUI so not the spoil the host OS with lots of installations.

It supports all processor types such as running ARM on x86 or running
x86 on ARM which is not available with other VM solutions.

Moreover, the host system can decide to share a folder with all
virtual environments, share it's network connection in bridged mode
or create a host only network for local development.

The VMs are accessible in a browser, on VNC, RDP, SSH or on command line.

Typical use-cases are:
- Run windows 7, 8, 10/11 or macOS in a browser.
- Run a specific version of a compiler or apache web server.
- Run a php development environment without installing php on the host
  system.
- Run 2 different linux distributions next to each other
  simultaneously.

Project status:
---------------

_**Following are mainstream OS releases. For more systems, please look
down to the legacy OS section.**_

  | **Platform**  | **Status** | **Remarks** |
  |---|---|---|
  | Win10      | ✅   | |
  | Win11      | ✅   | |
  | macOS14    | ✅   | |
  | macOS15    | ✅   | format disk as macOS extended, using APFS fails |
  | macOS26    | ✅   | |
  | android10  | ❌   | work still ongoing |
  | android11  | ❌   | work still ongoing |
  | linux gui  | ✅   | supports: fedora, mint, debian, arch, ubuntu, kali, ... |
  | fedora42   | ✅✅ | clang belofte |
  | fedora43   | ✅   | clang |
  | samba      | ✔️   | not ready for production |

_Windows only works for 90 days, after that it reboots every 60 minutes.
Please activate it or reinstall after 90 days._

_Apple silicon and windows ARM are untested, both as host and guest._

Installation instructions:
--------------------------

- Download and unzip/untargzip in the folder of your choice;
- Make sure all shell scripts have execute rights (`chmod +x *.sh`);
- Optionally run `create-network.sh` and `create-storage.sh`;
- Launch GUI or command line application of your choice;

Instructions for GUI applications:
----------------------------------

- create vm with: `podman compose --file win7.yaml up`
- stop it: `podman stop win7`
- start it again: `podman start win7`

_win7 can be replaced by any of the .yaml files, e.g. macos11 or android10_

Instructions for command line tools:
------------------------------------

- create vm with: `podman compose --file fedora42-clang.yaml up --detach`
- enter it with: `podman exec -it fedora42-clang /bin/bash`
- stop it: `podman stop fedora42-clang`
- start it again: `podman start fedora42-clang`

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

```bash
./create_storage.sh
```

Networking:
-----------

While bridging as a separate machine in the host connected network is the easy part, it has some
security implications. By default, a local network is being created with differing environments seeing
each other but no direct access from the internet is possible. A proxy will be used for that
purpose.

Setting up local network configuration on the host machine can be done with following script:

```bash
./create_network.sh
```

Syncing:
--------

A sync should take place in between the share folder and the kvms folder so
scripts can be shared with different environments. Update the `sync_Data.sh` script to change
the backup or synchronisation location.

Artifacts:
----------

Please see the [doc/TODO.md](TODO.md) file for a complete list of issues.

- Windows starts rebooting each hour after 90 days. This is by design, you need to activate your
  windows or re-install after 90 days.

- Samba server does require listening on port 445, as a non-root user, this is forbidden.
  Change system as follows, add following line to `/etc/sysctl.conf`:
  ```
  net.ipv4.ip_unprivileged_port_start=445
  ```
  Now issue the following command: `sysctl -p`

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
To do the same with docker, you have to install multiple un-vetted containers.
Here you are in full control.

- What is the security compared to docker?

Docker runs as root, and uses un-vetted containers. Here the installation scripts
are available in source code and can be modified or inspected. Podman runs as an
application and can be disabled simply by stopping the container. A compromised
container on docker can compromise the complete system. Here, the container source
is open by default, it does not run until started and has no root priviledges.

- How is this project different from VirtualBox?

Virtualbox is heavy and needs a lot of maintenance for each environment. Virtualbox
is also limited to run on the same processor architecture in emulation only.
Virtualbox does not run command line environments.
Kvms-easy does allow to run e.g. compilers or tool-sets on top of your linux. It
also allows to run ARM on x86 or x86 on ARM hosts. Kvms-easy requires much less
resources.

- What are unique features of this project?

Can you imagine running windows 10, 7 or macOS on your Linux machine in a browser?
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
The available tools like AppImage/Snap/Flatpak have their own drawbacks.
I also wanted to reduce disk space and maintenance for all my different VMs. And
last but not least, I wanted to run different versions of macOS or windows or
android without the maintenance burden. The real challenge was running android
ARM on windows boxes without going through the Android developer tools. Another
challenge was running recent macOS on more performant machines. All this while
maintaining maximum security and minimal attack surface.

Legacy OSes:
------------

Following legacy OSes are also supported:

  | **Platform**  | **Status** | **Remarks** |
  |---|---|---|
  | Win3.11    | ❌   | |
  | Win95      | ❌   | |
  | Win98      | ❌   | |
  | Win2000    | ✅   | |
  | WinMe      | ❌   | |
  | WinXP      | ✔️   | no access to shared data |
  | WinVista   | ✅   | |
  | Win7       | ✅   | |
  | Win8.1     | ✅   | |
  | macOS10.14 | ❌   | latest version with 32 bit support |
  | macOS11    | ✅   | |
  | macOS12    | ✅   | |
  | macOS13    | ✅   | format disk as macOS extended, using APFS fails |
  | android9   | ❌   | |
  | fedora40   | ✅   | clang |
  | fedora41   | ✅✅ | clang gcc |

Credits:
--------

The samba set-up script is forked from the project:
https://github.com/axrusar/samba-shared-folder-linux-mint

Author:
-------

Yves De Billoëz
22-12-2025

License:
--------

This is the README.md file for kvms-easy project
released under the license GNU - GPL v2.0. Please see the 
[doc/COPYING.md](COPYING.md) file for more information.

Further reading and sources:
----------------------------

Nothing would be possible without the foundation of these projects.

- https://github.com/qemus/qemu
- https://github.com/dockur/windows
- https://github.com/dockur/macos

The belofte scripts are being used to compile one of my other projects
that can be found here:

- https://sourceforge.net/projects/belofte/

## A special thanks to

**Richard Stallman** for his work on GNU in general and his vision
on free software.

_File last updated on 22/12/2025_