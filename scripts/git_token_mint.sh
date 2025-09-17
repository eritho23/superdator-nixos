#!/usr/bin/env bash
set -euo pipefail

### START OF CONFIG -----------------------------------------------------------

GITHUB_HOST="${GITHUB_HOST:-github.com}"
GITHUB_APP_ID="${GITHUB_APP_ID:-1966471}"

# Installation id repo mapping 
# [<installation id>]=<repo>
# NOTE: Duplicate installation ids are fine
declare -A INSTALLATION_IDS=(
  [86333494]="hgguspet/Thermometer-project"
)

GITHUB_APP_KEY_FILE="$GITHUB_APP_KEY_FILE"
GITHUB_APP_KEY_TMP=""

# NIX_EXPORT  -> prints: export NIX_CONFIG='access-tokens = ...'
# NIX_SNIPPET {or anything else} -> prints nix.conf lines: access-tokens = ...
OUTPUT_MODE="${OUTPUT_MODE:-NIX_EXPORT}"

### END OF CONFIG -------------------------------------------------------------

_die() { echo -e "[ \033[31mERROR\033[0m ] $*" >&2; exit 1; }
_need() { command -v "$1" >/dev/null 2>&1 || _die "Missing dependency: $1"; }

# Date
_date_epoch_utc() { date -u +%s; }
_date_to_epoch_utc() {
  if date -u -d @0 >/dev/null 2>&1; then
    # GNU date
    date -u -d "$1" +%s
  elif command -v gdate >/dev/null 2>&1; then
    gdate -u -d "$1" +%s
  else
    python3 - <<EOF
import sys, datetime
from email.utils import parsedate_to_datetime
print(int(parsedate_to_datetime("$1").timestamp()))
EOF
  fi
}

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

# Ensure jq/openssl/curl
_need jq
_need openssl
_need curl

# Load priv key
_load_private_key() {
  if [[ -n "${GITHUB_APP_KEY_PEM:-}" ]]; then
    GITHUB_APP_KEY_TMP="$(mktemp)"
    chmod 600 "$GITHUB_APP_KEY_TMP"
    printf '%s' "$GITHUB_APP_KEY_PEM" > "$GITHUB_APP_KEY_TMP"
    echo "$GITHUB_APP_KEY_TMP"
  elif [[ -n "${GITHUB_APP_KEY_FILE:-}" && -r "${GITHUB_APP_KEY_FILE}" ]]; then
    echo "$GITHUB_APP_KEY_FILE"
  elif [[ -r "$GITHUB_APP_KEY_FILE" ]]; then
    echo "$GITHUB_APP_KEY_FILE"
  else
    _die "No GitHub App private key found. Provide GITHUB_APP_KEY_PEM or GITHUB_APP_KEY_FILE."
  fi
}

_cleanup_tmp() { [[ -n "$GITHUB_APP_KEY_TMP" ]] && rm -f "$GITHUB_APP_KEY_TMP" || true; }
trap _cleanup_tmp EXIT

# Get JWT valid 10 min 
_mint_app_jwt() {
  local key_file="$1"
  local now iat exp header payload unsigned sig
  now=$(_date_epoch_utc)
  iat=$((now - 60))
  exp=$((now + 540)) # 9 minutes (max 10)

  header=$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)
  payload=$(printf '{"iat":%d,"exp":%d,"iss":"%s"}' "$iat" "$exp" "$GITHUB_APP_ID" | b64url)
  unsigned="${header}.${payload}"
  sig=$(printf %s "$unsigned" | openssl dgst -sha256 -sign "$key_file" -binary | b64url)
  printf '%s.%s' "$unsigned" "$sig"
}

# Get install token 1h
_mint_installation_token() {
  local jwt="$1" inst_id="$2"
  local url="https://api.${GITHUB_HOST}/app/installations/${inst_id}/access_tokens"
  local resp http_code
  resp="$(mktemp)"
  http_code=$(curl -sS -o "$resp" -w "%{http_code}" -X POST \
    -H "Authorization: Bearer ${jwt}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$url")

  if [[ "$http_code" != "200" && "$http_code" != "201" ]]; then
    echo "----- GitHub response for installation ${inst_id} (HTTP $http_code) -----" >&2
    cat "$resp" >&2
    rm -f "$resp"
    return 2
  fi

  jq -c '.' < "$resp"
  rm -f "$resp"
}

main() {
  local key_file jwt
  key_file="$(_load_private_key)"
  jwt="$(_mint_app_jwt "$key_file")"

  declare -a cfg_entries=()
  echo -e "[ \033[32mok\033[0m ] Fetched GitHub App JWT for app ${GITHUB_APP_ID}" >&2
  echo "Summary:" >&2

  for inst_id in "${!INSTALLATION_IDS[@]}"; do
    local repos_string token expires repo_sel now exp ttl ttlm masked
    repos_string="${INSTALLATION_IDS[$inst_id]}"
    resp_json="$(_mint_installation_token "$jwt" "$inst_id")" || _die "Failed to mint token for installation $inst_id"

    token=$(jq -r '.token // empty' <<<"$resp_json")
    expires=$(jq -r '.expires_at // empty' <<<"$resp_json")
    repo_sel=$(jq -r '.repository_selection // empty' <<<"$resp_json")
    [[ -z "$token" || -z "$expires" ]] && _die "Missing token/expires_at for installation $inst_id"

    now=$(_date_epoch_utc)
    exp=$(_date_to_epoch_utc "$expires")
    ttl=$((exp - now)); (( ttl < 0 )) && ttl=0
    ttlm=$((ttl / 60))

    masked="${token:0:8}..."
    
    # Parse space-separated repos from the config
    read -ra repos <<< "$repos_string"
    
    printf '  - installation=%s repos=(%s) token=%s ttl≈%sm expires=%s selection=%s\n' \
      "$inst_id" "$(IFS=', '; echo "${repos[*]}")" "$masked" "$ttlm" "$expires" "$repo_sel" >&2

    # Create access token entries for each repo/org
    for repo_path in "${repos[@]}"; do
      # Each repo path gets the same token, scoped by path prefix to avoid collisions
      cfg_entries+=("github.com/${repo_path}=${token}")
    done
  done

  # Emit result
  if [[ "$OUTPUT_MODE" == "NIX_EXPORT" ]]; then
    # shell export for $(eval ./script.sh) 
    printf "export NIX_CONFIG='access-tokens = %s'\n" "$(IFS=' '; echo "${cfg_entries[*]}")"
  else
    # nix.conf snippet (paste into ~/.config/nix/nix.conf)
    printf "access-tokens = %s\n" "$(IFS=' '; echo "${cfg_entries[*]}")"
  fi
}

main "$@"
