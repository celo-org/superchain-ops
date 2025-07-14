#!/usr/bin/env bash
set -euo pipefail

SIMULATE_WITHOUT_LEDGER=1 SIGNER_ADDRESS=0xe571b94CF7e95C46DFe6bEa529335f4A11d15D92 just --dotenv-path $(pwd)/.env --justfile ../../../nested.just simulate
