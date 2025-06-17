#!/usr/bin/env bash
set -euo pipefail

[ -z "$SIGNER_PK" ] && echo "Need to set the SIGNER_PK via env" && exit 1;

SIMULATE_WITHOUT_LEDGER=1 PK_OWNER=$SIGNER_PK PK_EXEC=$SIGNER_PK just --dotenv-path $(pwd)/.env --justfile ../../../single.just sign_and_execute_in_anvil 0xd542f3328ff2516443FE4db1c89E427F67169D94
