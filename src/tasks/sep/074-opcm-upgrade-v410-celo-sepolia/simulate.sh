#!/usr/bin/env bash
set -euo pipefail

JUSTFILE="../../../justfile"
DOTENV="$(pwd)/.env"

echo "=== Simulating for ChildSafe1 ==="
SIMULATE_WITHOUT_LEDGER=1 just --dotenv-path "$DOTENV" --justfile "$JUSTFILE" simulate ChildSafe1

echo ""
echo "=== Simulating for ChildSafe2 ==="
SIMULATE_WITHOUT_LEDGER=1 just --dotenv-path "$DOTENV" --justfile "$JUSTFILE" simulate ChildSafe2
