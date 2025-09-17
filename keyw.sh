#!/usr/bin/env bash
set -euo pipefail

# Sops file
SOPS_FILE="./secrets/secrets.yaml"
KEY_FIELD="git_priv_key"

_die() { echo -e "[ \033[31mERROR\033[0m ] $*" >&2; exit 1; }
_need() { command -v "$1" >/dev/null 2>&1 || _die "Missing dependency: $1"; }

_need sops
_need yq # Decode yaml file

extract_github_key() {
  local sops_file="$SOPS_FILE"
  local key_field="$KEY_FIELD"
  local temp_key
  
  [[ ! -r "$sops_file" ]] && _die "Cannot read sops file: $sops_file"
  
  temp_key="$(mktemp)"
  chmod 600 "$temp_key"
  
  # Extract the private key from YAML sops file using yq
  if ! sops -d "$sops_file" | yq -r ".$key_field // empty" > "$temp_key" 2>/dev/null; then
    rm -f "$temp_key"
    _die "Failed to extract $key_field from sops file: $sops_file"
  fi
  
  # Verify key avaliable
  if [[ ! -s "$temp_key" || "$(cat "$temp_key")" == "null" ]]; then
    rm -f "$temp_key"
    _die "No $key_field found in sops file: $sops_file"
  fi
  
  echo "$temp_key"
}

# Extract GitHub key and set environment variable
KEY_FILE=$(extract_github_key)
export GITHUB_APP_KEY_FILE="$KEY_FILE"

# mint installation tokens
eval "$("${PWD}/scripts/git_token_mint.sh")"

# Clean up
rm -f "$KEY_FILE"

# run provided command
exec "$@"
