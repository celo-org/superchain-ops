#!/usr/bin/env bash
set -euo pipefail

[ -z "$SIGNER_PK" ] && echo "Need to set the SIGNER_PK via env" && exit 1;

SIMULATE_WITHOUT_LEDGER=1 PK_OWNER=$SIGNER_PK PK_EXEC=$SIGNER_PK just --dotenv-path $(pwd)/.env --justfile ../../../single.just sign_and_execute_in_anvil 0xf05f102e890E713DC9dc0a5e13A8879D5296ee48
