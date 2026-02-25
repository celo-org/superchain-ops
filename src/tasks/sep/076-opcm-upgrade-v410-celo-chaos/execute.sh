#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Sign & Execute OPCM v4.1.0 upgrade for Celo Chaos Testnet
# ============================================================
# Usage: SIGNER_PK=0x... RPC_URL=https://... ./execute.sh
# ============================================================

[ -z "${SIGNER_PK:-}" ] && echo "Error: SIGNER_PK env var is required" && exit 1
[ -z "${RPC_URL:-}" ] && echo "Error: RPC_URL env var is required" && exit 1

JUSTFILE="../../../justfile"

export PRIVATE_KEY="$SIGNER_PK"
export SIMULATE_WITHOUT_LEDGER=1
export OVERRIDE_RPC_URL="$RPC_URL"

echo "=== Step 1: Signing Safe transaction ==="

SIGN_OUTPUT=$(just --dotenv-path "$(pwd)/.env" --justfile "$JUSTFILE" sign 2>&1)
SIGNATURE=$(echo "$SIGN_OUTPUT" | grep '^Signature:' | awk '{print $2}')

if [ -z "$SIGNATURE" ]; then
  echo "Failed to extract signature. Output:"
  echo "$SIGN_OUTPUT" | tail -30
  exit 1
fi

echo "✅ Signature obtained: 0x${SIGNATURE:0:16}..."
echo ""

echo "=== Step 2: Executing on-chain ==="

SIGNATURES="0x$SIGNATURE" just --dotenv-path "$(pwd)/.env" --justfile "$JUSTFILE" execute

echo ""
echo "✅ Execution complete!"
