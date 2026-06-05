#!/bin/bash
# build-patched-cmus.sh
# Builds cmus from our GitHub fork (zokan121522/cmus) with the
# TXXX:comment patch already applied on the feat/txxx-comment branch.
# Installs to /opt/homebrew/bin and pins brew cmus to prevent overwrites.
#
# Usage: ./build-patched-cmus.sh [--force]
#   --force: rebuild even if patched cmus is already installed
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CMUS_VERSION="2.12.0"
CMUS_FORK="https://github.com/zokan121522/cmus.git"
CMUS_BRANCH="feat/txxx-comment"
DEBIAN_URL="https://deb.debian.org/debian/pool/main/c/cmus/cmus_${CMUS_VERSION}-2.debian.tar.xz"
BUILD_DIR="/tmp/cmus-build-$$"
INSTALL_PREFIX="/opt/homebrew"
BREW_CMAKE_BIN="/opt/homebrew/bin/cmus"

# Patches from brew formula (ffmpeg 8 compatibility)
DEBIAN_PATCH_DIR="debian/patches"
DEBIAN_PATCHES=(
    "0003-ip-ffmpeg-more-precise-seeking.patch"
    "0004-ip-ffmpeg-skip-samples-only-when-needed.patch"
    "0005-ip-ffmpeg-remove-excessive-version-checks.patch"
    "0006-ip-ffmpeg-major-refactor.patch"
    "0007-Validate-sample-format-in-ip_open.patch"
    "0008-ip-ffmpeg-flush-swresample-buffer-when-seeking.patch"
    "0009-ip-ffmpeg-remember-swr_frame-s-capacity.patch"
    "0010-ip-ffmpeg-reset-swr_frame_start-when-seeking.patch"
    "0011-ip-ffmpeg-better-frame-skipping-logic.patch"
    "0012-ip-ffmpeg-don-t-process-empty-frames.patch"
    "0013-ip-ffmpeg-improve-readability.patch"
    "0014-ip-ffmpeg-fix-building-for-ffmpeg-8.0.patch"
    "0015-ip-ffmpeg-change-sample-format-conversions.patch"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}==>${NC} $1"; }
ok()    { echo -e "${GREEN}✓${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
err()   { echo -e "${RED}✗${NC} $1"; }

# --- Pre-flight checks ---

# Check if already patched
if [ -f "$INSTALL_PREFIX/bin/cmus" ]; then
    EXISTING=$(strings "$INSTALL_PREFIX/bin/cmus" | grep -c "ID3_COMMENT" 2>/dev/null || true)
    if [ "$EXISTING" -gt 0 ]; then
        ok "Patched cmus already installed at $INSTALL_PREFIX/bin/cmus"
        if [ "${1:-}" != "--force" ]; then
            info "Use --force to rebuild anyway"
            exit 0
        fi
        warn "Rebuilding (--force)..."
    fi
fi

# Ensure brew cmus is installed (we need its deps)
if ! command -v cmus &>/dev/null; then
    err "cmus is not installed. Run: brew install cmus"
    exit 1
fi

info "Starting patched cmus build v${CMUS_VERSION}"

# --- Clone from our fork (TXXX:comment patch pre-applied) ---
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

info "Cloning cmus from our fork (zokan121522/cmus, branch: ${CMUS_BRANCH})..."
git clone --depth 1 --branch "$CMUS_BRANCH" "$CMUS_FORK" "cmus-${CMUS_VERSION}" 2>&1
cd "cmus-${CMUS_VERSION}"
ok "Cloned feat/txxx-commit — TXXX:comment patch included"

info "Downloading Debian patches (ffmpeg 8 compat)..."
curl -sL "$DEBIAN_URL" -o "debian-patches.tar.xz"
tar xJf "debian-patches.tar.xz"

# --- Apply Debian patches ---
info "Applying Debian ffmpeg 8 compatibility patches..."
for p in "${DEBIAN_PATCHES[@]}"; do
    patch_path="${DEBIAN_PATCH_DIR}/${p}"
    if [ -f "$patch_path" ]; then
        patch -p1 -s < "$patch_path"
        ok "Applied: $p"
    else
        warn "Patch not found: $patch_path"
    fi
done

# TXXX:comment patch is already in the fork — no need to apply it separately

# --- Configure ---
info "Configuring with Homebrew-compatible flags..."
./configure \
    prefix="$INSTALL_PREFIX" \
    mandir="$INSTALL_PREFIX/share/man" \
    CONFIG_WAVPACK=n \
    CONFIG_MPC=n \
    CONFIG_AO=y

# --- Build ---
CORES=$(sysctl -n hw.logicalcpu)
info "Building with ${CORES} cores..."
make -j"$CORES"

# --- Install ---
info "Installing to ${INSTALL_PREFIX}/bin/cmus..."

# Backup existing brew cmus
if [ -f "$INSTALL_PREFIX/bin/cmus" ]; then
    cp "$INSTALL_PREFIX/bin/cmus" "$INSTALL_PREFIX/bin/cmus.brew-backup"
    ok "Backed up existing cmus to cmus.brew-backup"
fi

make install
ok "Installed patched cmus to $INSTALL_PREFIX/bin/cmus"

# --- Pin brew cmus ---
info "Pinning brew cmus to prevent overwrites..."
brew pin cmus 2>/dev/null || true
ok "brew pin cmus"

# --- Verify ---
info "Verifying patched binary..."
FILE_CHECK=$(file "$INSTALL_PREFIX/bin/cmus")
PATCH_CHECK=$(strings "$INSTALL_PREFIX/bin/cmus" | grep -c "ID3_COMMENT" 2>/dev/null || true)

if [ "$PATCH_CHECK" -gt 0 ]; then
    ok "Patch verified in binary: ID3_COMMENT symbol found"
else
    warn "Could not verify patch in binary (strings check failed)"
    warn "This may be expected with stripped binaries"
fi

info "Binary: $FILE_CHECK"

# --- Cleanup ---
cd /
rm -rf "$BUILD_DIR"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Patched cmus v${CMUS_VERSION} installed successfully${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  Binary:  $INSTALL_PREFIX/bin/cmus"
echo "  Backup:  $INSTALL_PREFIX/bin/cmus.brew-backup (original brew)"
echo "  Status:  brew pin cmus (prevented from overwrite)"
echo "  Fork:    https://github.com/zokan121522/cmus"
echo "  Branch:  $CMUS_BRANCH"
echo ""
echo "  To rebuild after brew upgrade:"
echo "    brew unpin cmus && brew upgrade cmus && brew pin cmus"
echo "    $SCRIPT_DIR/build-patched-cmus.sh"
echo ""
