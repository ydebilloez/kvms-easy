# Changelist
@brief All changes per release, version specific information

This is the [HISTORY.md](HISTORY.md) file for kvms-easy.

<!-- SPDX-License-Identifier: GPL-2.0-only -->

## 1.1

<u>Updated on 22/12/2025</u>

- Bug-fix: In Fedora host, selinux is active. Shared drive cannot be used
  and storage volume prevents guest to launch. Adding :Z to volume
  descriptors fixes it;
- Fix: In fedora host, all containers are added to same pod. Compose
  action is deleting all inactive pods. Added x-podman: in_pod directive
  to prevent other containers to be deleted upon creation of new one;
- Change: all environments have been tested and included in readme file;
- Change: clean up project by moving files to sub-folders;
- Improvement: increased memory allocation so containers run more
  smoothly;
- Improvement: add project status and FAQ to readme;
- Improvement: all fedora based containers get their own disk instead
  of sharing the same disk;

## 1.0

<u>Released on 12/12/2025</u>

- First release

*eof*
