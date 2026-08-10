#!/bin/sh
set -eu

REPOSITORY_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$REPOSITORY_ROOT"

XCODE_MAJOR="$(xcodebuild -version | awk 'NR == 1 { split($2, version, "."); print version[1] }')"

if [ "$XCODE_MAJOR" != "27" ]; then
  echo "Refusing to build MeloNX 2.5 with Xcode major version ${XCODE_MAJOR:-unknown}; Xcode 27 is required."
  exit 1
fi

if [ ! -x "$HOME/.dotnet/dotnet" ]; then
  echo "The required .NET SDK was not prepared by ci_post_clone.sh."
  exit 1
fi

export PATH="$HOME/.dotnet:$PATH"

dotnet --version
test -f "src/Ryujinx.Library/Ryujinx.Library.csproj"
test -f "src/MeloNX/MeloNX/MeloNX.entitlements"
test -f "src/MeloNX/MeloNX/Info.plist"
test -f "src/MeloNX/MeloNX/Core/MeloNX-Bridging-Header.h"

echo "MeloNX 2.5 pre-build validation passed."
