#!/usr/bin/env bash
set -euo pipefail

SIMULATE_WITHOUT_LEDGER=1 SIGNER_ADDRESS=0x22EaF69162ae49605441229EdbEF7D9FC5f4f094 just --dotenv-path $(pwd)/.env --justfile ../../../single.just simulate
