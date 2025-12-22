# Todo
@brief Issues known and planned for upcoming releases

This is the TODO.md file for kvms-easy.
This list is what we call, a TODO list.

<!-- SPDX-License-Identifier: GPL-2.0-only -->

## Bugs

- Creating a folder inside the data disk assigns it to the Linux user with id 166535.

- Windows RDP is not working on Win7.

- Windows XP is not accessing shared data folder. Link is invalid as per windows.

- macOS26 shows rectangular window borders next to rounded corners creating
  artifacts in corners of various windows.

## Enhancements and features

- Running on Fedora host gives error during compose: "Warning: you are
  using the BTRFS filesystem for /storage, this might introduce issues
  with Windows Setup!"

- Checking health of a container is mandatory before using it in case of tool-containers.
  e.g. `podman healthcheck run fedora-clang`
  It will return unhealthy in case the initialisation script is not finished.

## Other elements and TODO's

- The samba share on the host system is not working yet.

- The samba server project is not working yet.

- The android emulation is not working yet.

- Add NodeJS environment.

- Add PHP/MySQL development environment.

- Installing macOS13, macOS14, macOS15 and macOS26 takes hours to complete, it should run
  faster.

- Allow installation based on ISO file instead of automatic download of recovery
  image.

  _File last updated on 22/12/2025_