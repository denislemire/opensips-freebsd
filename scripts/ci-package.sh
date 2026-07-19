#!/bin/sh
# Build net/opensips against a sparse FreeBSD ports tree and emit dist/*.pkg
# Fail-closed: remove any partial package on error so CircleCI never stores junk.
set -eu

export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:${PATH:-}"

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
PORT_SRC="${ROOT}/net/opensips"
OUT_DIR="${ROOT}/dist"
PORTS_TREE="${PORTS_TREE:-/usr/ports}"
PKG_OUT=""

fail_cleanup() {
	_ret=$?
	if [ "${_ret}" -ne 0 ]; then
		echo "ci-package failed — removing partial packages from ${OUT_DIR}" >&2
		rm -f "${OUT_DIR}"/opensips-*.pkg 2>/dev/null || true
	fi
	exit "${_ret}"
}
trap fail_cleanup EXIT

test -f "${PORT_SRC}/Makefile"
test -f "${PORT_SRC}/pkg-descr"
test -f "${PORT_SRC}/files/opensips.in"

mkdir -p "${OUT_DIR}"
rm -f "${OUT_DIR}"/opensips-*.pkg

if [ ! -f "${PORTS_TREE}/Mk/bsd.port.mk" ]; then
	echo "Bootstrapping sparse ports tree at ${PORTS_TREE}"
	sudo mkdir -p "${PORTS_TREE}"
	TMP="$(mktemp -d /tmp/ports-XXXXXX)"
	git clone --depth 1 --filter=blob:none --sparse \
		https://github.com/freebsd/freebsd-ports.git "${TMP}/ports"
	(
		cd "${TMP}/ports"
		# Cone mode only accepts directories — UIDs/GIDs are root files.
		git sparse-checkout set Mk Templates Keywords Tools
	)
	# Root UID/GID maps: fetch as plain files (not sparse-checkout paths).
	curl -fsSL -o "${TMP}/ports/UIDs" \
		https://raw.githubusercontent.com/freebsd/freebsd-ports/main/UIDs
	curl -fsSL -o "${TMP}/ports/GIDs" \
		https://raw.githubusercontent.com/freebsd/freebsd-ports/main/GIDs
	# Prefer merging into an empty tree; sudo install for /usr/ports.
	sudo mkdir -p "${PORTS_TREE}"
	sudo cp -a "${TMP}/ports/Mk" "${TMP}/ports/Templates" \
		"${TMP}/ports/Keywords" "${TMP}/ports/Tools" \
		"${TMP}/ports/UIDs" "${TMP}/ports/GIDs" "${PORTS_TREE}/"
	rm -rf "${TMP}"
fi

# Ensure USERS/GROUPS entries exist (removed with the old net/opensips port).
if ! grep -q '^opensips:' "${PORTS_TREE}/UIDs" 2>/dev/null; then
	echo "opensips:*:364:364::0:0:OpenSIPS Daemon:/nonexistent:/usr/sbin/nologin" \
		| sudo tee -a "${PORTS_TREE}/UIDs" >/dev/null
fi
if ! grep -q '^opensips:' "${PORTS_TREE}/GIDs" 2>/dev/null; then
	echo "opensips:*:364:" | sudo tee -a "${PORTS_TREE}/GIDs" >/dev/null
fi

sudo mkdir -p "${PORTS_TREE}/net"
sudo rm -rf "${PORTS_TREE}/net/opensips"
sudo cp -a "${PORT_SRC}" "${PORTS_TREE}/net/opensips"

# Build dependencies as packages when possible.
# DISABLE_CHECK_PLIST: OPTIONS_SUB pkg-plist is best-effort until exercised
# under every knob; default OPTIONS still produce a usable .pkg artifact.
cd "${PORTS_TREE}/net/opensips"
sudo make -C "${PORTS_TREE}/net/opensips" \
	BATCH=yes \
	USE_PACKAGE_DEPENDS=yes \
	DISABLE_VULNERABILITIES=yes \
	DISABLE_CHECK_PLIST=yes \
	clean package

PKG_BUILT="$(find "${PORTS_TREE}/net/opensips/work/pkg" -name 'opensips-*.pkg' -type f 2>/dev/null | head -1)"
if [ -z "${PKG_BUILT}" ]; then
	PKG_BUILT="$(find /usr/ports/packages /var/cache/pkg "${PORTS_TREE}/packages" \
		-name 'opensips-*.pkg' -type f 2>/dev/null | head -1 || true)"
fi
# make package leaves the .pkg next to the port as ../../packages/All or in work
if [ -z "${PKG_BUILT}" ]; then
	PKG_BUILT="$(find "${PORTS_TREE}" -path '*packages*' -name 'opensips-*.pkg' -type f 2>/dev/null | head -1 || true)"
fi
if [ -z "${PKG_BUILT}" ]; then
	# FreeBSD 14+/15: PKGFILE may be under WRKDIR
	PKG_BUILT="$(find "${PORTS_TREE}/net/opensips" -name 'opensips-*.pkg' -type f 2>/dev/null | head -1 || true)"
fi
test -n "${PKG_BUILT}"

VER="$(pkg query -F "${PKG_BUILT}" %v)"
PKG_OUT="${OUT_DIR}/opensips-${VER}.pkg"
cp -f "${PKG_BUILT}" "${PKG_OUT}"

BYTES="$(stat -f '%z' "${PKG_OUT}")"
if [ "${BYTES}" -lt 100000 ]; then
	echo "pkg too small (${BYTES} bytes) — likely empty" >&2
	exit 1
fi

echo "=== pkg info ==="
pkg info -F "${PKG_OUT}"
echo "=== pkg files (head) ==="
pkg info -l -F "${PKG_OUT}" | head -60
ls -la "${PKG_OUT}"

trap - EXIT
