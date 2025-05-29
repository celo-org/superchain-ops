#!/usr/bin/env bash
set -euo pipefail

[ -z "$DEPLOY_PRIVATE_KEY" ] && echo "Need to set the DEPLOY_PRIVATE_KEY via env" && exit 1;

SIMULATE_WITHOUT_LEDGER=1 PK_OWNER=$DEPLOY_PRIVATE_KEY PK_EXEC=$DEPLOY_PRIVATE_KEY just --dotenv-path $(pwd)/.env --justfile ../../../single.just sign_and_execute_in_anvil 0xd542f3328ff2516443FE4db1c89E427F67169D94
