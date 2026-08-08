#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.dotnet:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

DOTNET="${DOTNET:-}"

if [ -z "$DOTNET" ] && [ -n "${DOTNET_ROOT:-}" ] && [ -x "$DOTNET_ROOT/dotnet" ]; then
  DOTNET="$DOTNET_ROOT/dotnet"
fi

if [ -z "$DOTNET" ]; then
  DOTNET=$(command -v dotnet || true)
fi

if [ -z "$DOTNET" ]; then
  for candidate in \
    "/opt/homebrew/bin/dotnet" \
    "/usr/local/bin/dotnet" \
    "/usr/local/share/dotnet/dotnet" \
    "$HOME/.dotnet/dotnet"
  do
    if [ -x "$candidate" ]; then
      DOTNET="$candidate"
      break
    fi
  done
fi

if [ -z "$DOTNET" ]; then
  echo "dotnet not found"
  exit 1
fi

"$DOTNET" publish -c Release -r ios-arm64 -p:ExtraDefineConstants=DISABLE_UPDATER src/Ryujinx.Library --self-contained true
