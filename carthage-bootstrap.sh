#!/bin/bash
# Builds the Carthage dependencies for Apple Silicon only (settings in Carthage.xcconfig).
set -euo pipefail
cd "$(dirname "$0")"

export XCODE_XCCONFIG_FILE="$PWD/Carthage.xcconfig"

carthage checkout

# Without an explicit destination, Xcode 26 resolves iOS/tvOS/watchOS schemes to "My Mac (Designed for iPad)",
# so Carthage mistakes them for macOS schemes. Remove the shared schemes whose target can't build for macOS.
find Carthage/Checkouts -path '*/xcshareddata/xcschemes/*.xcscheme' -not -path 'Carthage/Checkouts/*/Carthage/*' | while read -r scheme; do
    container_dir=$(dirname "$(dirname "$(dirname "$(dirname "$scheme")")")")
    project=$(grep -m1 -o 'ReferencedContainer = "container:[^"]*"' "$scheme" | sed 's/.*container:\(.*\)"/\1/' || true)
    target=$(grep -m1 -o 'BlueprintName = "[^"]*"' "$scheme" | cut -d'"' -f2 || true)
    [ -n "$project" ] && [ -n "$target" ] || continue

    platforms=$(xcodebuild -project "$container_dir/$project" -target "$target" -showBuildSettings 2>/dev/null \
        | awk -F' = ' '/^ *SUPPORTED_PLATFORMS =/ { print $2; exit }' || true)
    case " $platforms " in
        *" macosx "*) ;;
        *) echo "*** Removing non-macOS scheme $scheme"; rm "$scheme" ;;
    esac
done

carthage build --platform macOS --no-use-binaries --cache-builds
