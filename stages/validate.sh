#!/usr/bin/env bash
# Validate all Nix files in the nixos-config project
# Usage: ./stages/validate.sh

set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Source Nix profile
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

echo "=== Validating Nix files in $CONFIG_DIR ==="
echo ""

ERRORS=0
OK=0

while IFS= read -r -d '' file; do
  if nix-instantiate --parse "$file" > /dev/null 2>&1; then
    echo "  OK: ${file#$CONFIG_DIR/}"
    ((OK++))
  else
    echo "  ERROR: ${file#$CONFIG_DIR/}"
    nix-instantiate --parse "$file" 2>&1 | head -5
    echo ""
    ((ERRORS++))
  fi
done < <(find "$CONFIG_DIR" -name "*.nix" -print0)

echo ""
echo "=== Results: $OK OK, $ERRORS errors ==="

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
