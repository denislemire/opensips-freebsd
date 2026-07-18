# OpenSIPS FreeBSD port (4.0)

Out-of-tree FreeBSD port for [OpenSIPS](https://www.opensips.org/) **4.0.0**,
built on EhWS CircleCI (`freebsd.medium` / `freebsd-15.1:current`) and stored
as a `.pkg` artifact.

Maintainer: Denis Lemire `<denis@lemire.name>`

## Layout

```
net/opensips/          FreeBSD port (OPTIONS / make config / make menuconfig)
  Makefile
  distinfo
  pkg-descr
  pkg-message
  pkg-plist
  files/
    Makefile.conf      OpenSIPS module exclude/include template
    opensips.in        rc.d script (sysrc / service opensips)
    opensips.cfg.sample
scripts/ci-package.sh  CI helper: sparse ports tree + make package
.circleci/config.yml
```

## Configure modules

On a FreeBSD system with a ports tree Mk infrastructure:

```sh
cd net/opensips
make menuconfig    # or: make config
make package BATCH=yes USE_PACKAGE_DEPENDS=yes
```

Default OPTIONS: **DOCS HTTP MYSQL PGSQL TLS**.

TLS pulls in `proto_tls`, `proto_wss`, `tls_mgm`, and `tls_openssl` (base OpenSSL).

## Install / rc.conf

```sh
pkg add ./dist/opensips-*.pkg
sysrc opensips_enable=YES
# optional:
# sysrc opensips_shmem_size=64 opensips_pkmem_size=8
service opensips start
```

Config lives at `/usr/local/etc/opensips/opensips.cfg` (from the `.sample`).

## CircleCI

Uses the EhWS KubeVirt FreeBSD machine executor:

| Field | Value |
|-------|--------|
| Image | `freebsd-15.1:current` |
| Resource class | `freebsd.medium` |

The job runs `scripts/ci-package.sh` and `store_artifacts` under
`opensips-freebsd-packages`.

## Notes

- Upstream `packaging/freebsd` is historical; this port follows the last
  official FreeBSD `net/opensips` (3.0.2, deleted 2020) patterns, refreshed
  for 4.0 OPTIONS and module names.
- Distfile is the GitHub `4.0.0` tag (opensips.org `/pub/opensips/4.0.0/`
  currently only publishes ChangeLog).
- UIDs/GIDs `opensips` (364) are seeded by the CI script when missing from
  the ports tree.
