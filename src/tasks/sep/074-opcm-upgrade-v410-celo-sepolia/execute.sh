#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Sign, Approve & Execute OPCM v4.1.0 upgrade on local anvil fork
# Nested Safe: 2-of-2 parent with two 1-of-2 child Safes
# ============================================================
# Usage (same EOA on both child Safes):
#   SIGNER_PK=0x... ./execute.sh
#
# Usage (different EOAs):
#   SIGNER_PK_1=0x... SIGNER_PK_2=0x... ./execute.sh
# ============================================================

PARENT_SAFE="0x009A6Ac23EeBe98488ED28A52af69Bf46F1C18cb"
CHILD_SAFE_1="0x769b480A8036873a2a5EB01FE39278e5Ab78Bb27"
CHILD_SAFE_2="0x3b00043E8C82006fbE5f56b47F9889a04c20c5d6"

if [ -n "${SIGNER_PK:-}" ]; then
  SIGNER_PK_1="$SIGNER_PK"
  SIGNER_PK_2="$SIGNER_PK"
fi

[ -z "${SIGNER_PK_1:-}" ] && echo "Error: SIGNER_PK or SIGNER_PK_1 env var required (owner on ChildSafe1)" && exit 1
[ -z "${SIGNER_PK_2:-}" ] && echo "Error: SIGNER_PK or SIGNER_PK_2 env var required (owner on ChildSafe2)" && exit 1

JUSTFILE="../../../justfile"
DOTENV="$(pwd)/.env"
export SIMULATE_WITHOUT_LEDGER=1

ROOT_DIR=$(git rev-parse --show-toplevel)
ETH_RPC_URL=$("$ROOT_DIR"/src/script/get-rpc-url.sh sep)

echo "=== Safe Nonce Check ==="
PARENT_NONCE=$(cast call "$PARENT_SAFE" "nonce()(uint256)" -r "$ETH_RPC_URL")
CHILD1_NONCE=$(cast call "$CHILD_SAFE_1" "nonce()(uint256)" -r "$ETH_RPC_URL")
CHILD2_NONCE=$(cast call "$CHILD_SAFE_2" "nonce()(uint256)" -r "$ETH_RPC_URL")
echo "  Parent  ($PARENT_SAFE): nonce=$PARENT_NONCE"
echo "  Child1  ($CHILD_SAFE_1): nonce=$CHILD1_NONCE"
echo "  Child2  ($CHILD_SAFE_2): nonce=$CHILD2_NONCE"
echo ""

sign_child() {
  local child_name="$1"
  local signer_pk="$2"

  export PRIVATE_KEY="$signer_pk"
  local output
  output=$(just --dotenv-path "$DOTENV" --justfile "$JUSTFILE" sign "$child_name" 2>&1)
  local sig
  sig=$(echo "$output" | grep '^Signature:' | awk '{print $2}')

  if [ -z "$sig" ]; then
    echo "Failed to extract signature for $child_name. Output:"
    echo "$output" | tail -30
    exit 1
  fi
  echo "$sig"
}

echo "=== Step 1/5: Signing from ChildSafe1 ==="
SIG1=$(sign_child ChildSafe1 "$SIGNER_PK_1")
echo "✅ ChildSafe1 signature: 0x${SIG1:0:16}..."
echo ""

echo "=== Step 2/5: Signing from ChildSafe2 ==="
SIG2=$(sign_child ChildSafe2 "$SIGNER_PK_2")
echo "✅ ChildSafe2 signature: 0x${SIG2:0:16}..."
echo ""

echo "=== Step 3/5: Approving from ChildSafe1 ==="
export PRIVATE_KEY="$SIGNER_PK_1"
SIGNATURES="0x$SIG1" just --dotenv-path "$DOTENV" --justfile "$JUSTFILE" approve ChildSafe1
echo "✅ ChildSafe1 approval broadcasted"
echo ""

echo "=== Step 4/5: Approving from ChildSafe2 ==="
export PRIVATE_KEY="$SIGNER_PK_2"
SIGNATURES="0x$SIG2" just --dotenv-path "$DOTENV" --justfile "$JUSTFILE" approve ChildSafe2
echo "✅ ChildSafe2 approval broadcasted"
echo ""

echo "=== Step 5/5: Executing from parent Safe ==="
export PRIVATE_KEY="$SIGNER_PK_1"
just --dotenv-path "$DOTENV" --justfile "$JUSTFILE" execute

echo ""
echo "✅ Nested Safe execution complete!"
