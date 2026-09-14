#!/bin/bash
# Converts a database written by the original NPS Browser (Realm 3.x, file format 9), which Realm 20
# can't open anymore, with Realm 10.48.1: the last version that can still upgrade that format.
# Usage: convert.sh [path/to/default.realm]
set -euo pipefail

DB="${1:-$HOME/Library/Application Support/JK3Y.NPS-Browser/default.realm}"
REALM_VERSION=10.48.1
REALM_ZIP_SHA256=9df06aa37e11a366d58b819d12e02ab25e456944c6eb67609538f3175fe57d8c

if pgrep -f "/Contents/MacOS/NPS Browser" >/dev/null; then
    echo "Quit NPS Browser and NPS Browser Silicon first." >&2
    exit 1
fi
if [ ! -f "$DB" ]; then
    echo "No database at $DB" >&2
    exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

echo "Downloading Realm $REALM_VERSION..."
curl -fsSL -o "$work/Realm.spm.zip" "https://github.com/realm/realm-swift/releases/download/v$REALM_VERSION/Realm.spm.zip"
echo "$REALM_ZIP_SHA256  $work/Realm.spm.zip" | shasum -a 256 -c - >/dev/null
unzip -q "$work/Realm.spm.zip" -d "$work"

frameworks="$work/Realm.xcframework/macos-arm64_x86_64"
clang -fobjc-arc -fmodules -arch arm64 -mmacosx-version-min=11.0 -F "$frameworks" -framework Realm \
    -Wl,-rpath,"$frameworks" -o "$work/realm-upgrade" "$(dirname "$0")/realm-upgrade.m"

backup="$DB.before-upgrade-$(date +%Y%m%d-%H%M%S)"
cp -p "$DB" "$backup"
echo "Backup: $backup"

"$work/realm-upgrade" "$DB"
echo "Done. NPS Browser Silicon can now open $DB"
