#!/bin/sh
set -eu

REPOSITORY_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$REPOSITORY_ROOT"

XCODE_VERSION_OUTPUT="$(xcodebuild -version)"
XCODE_MAJOR="$(printf '%s\n' "$XCODE_VERSION_OUTPUT" | awk 'NR == 1 { split($2, version, "."); print version[1] }')"

printf '%s\n' "$XCODE_VERSION_OUTPUT"

if [ "$XCODE_MAJOR" != "27" ]; then
  echo "MeloNX 2.5 Xcode Cloud builds require Xcode 27; selected runner reports major version ${XCODE_MAJOR:-unknown}."
  echo "Edit the Xcode Cloud workflow environment and select an available Xcode 27 beta."
  exit 1
fi

DOTNET_SDK_VERSION="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' global.json | head -n 1)"

if [ -z "$DOTNET_SDK_VERSION" ]; then
  echo "Unable to read the required .NET SDK version from global.json."
  exit 1
fi

if [ ! -x "$HOME/.dotnet/dotnet" ] || ! "$HOME/.dotnet/dotnet" --list-sdks | grep -q "^${DOTNET_SDK_VERSION} "; then
  INSTALL_SCRIPT="${TMPDIR:-/tmp}/melonx-dotnet-install.sh"
  curl --fail --location --silent --show-error https://dot.net/v1/dotnet-install.sh -o "$INSTALL_SCRIPT"
  chmod +x "$INSTALL_SCRIPT"
  "$INSTALL_SCRIPT" --version "$DOTNET_SDK_VERSION" --install-dir "$HOME/.dotnet" --no-path
fi

"$HOME/.dotnet/dotnet" --version

test -f "$REPOSITORY_ROOT/MeloNX.xcodeproj/project.pbxproj"
test -f "$REPOSITORY_ROOT/MeloNX.xcodeproj/xcshareddata/xcschemes/MeloNX.xcscheme"
test -x "$REPOSITORY_ROOT/distribution/ios/build.sh"

echo "MeloNX 2.5 post-clone setup is ready for Xcode 27."
