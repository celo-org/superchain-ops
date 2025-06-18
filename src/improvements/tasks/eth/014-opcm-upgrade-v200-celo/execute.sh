#!/usr/bin/env bash
set -euo pipefail

[ -z "$SIGNER_PK" ] && echo "Need to set the SIGNER_PK via env" && exit 1;

SIMULATE_WITHOUT_LEDGER=1 PK_OWNER=$SIGNER_PK PK_EXEC=$SIGNER_PK just --dotenv-path $(pwd)/.env --justfile ../../../nested.just sign_and_execute_in_anvil 0x4092A77bAF58fef0309452cEaCb09221e556E112 0xC03172263409584f7860C25B6eB4985f0f6F4636
