# 048-opcm-upgrade-v410-celo-mainnet: Mainnet OPCM v4.1.0: Celo Mainnet

Status: [DRAFT]()

## Objective

Executes [Upgrade 16a](https://gov.optimism.io/t/maintenance-upgrade-proposal-u16a/10288) on Mainnet for Celo Mainnet.

## Safe Architecture

| Safe | Address | Threshold | Owners |
|------|---------|-----------|--------|
| Parent (ProxyAdminOwner) | `0x4092A77bAF58fef0309452cEaCb09221e556E112` | 2-of-2 | ChildSafe1, ChildSafe2 |
| ChildSafe1 | `0x9Eb44Da23433b5cAA1c87e35594D15FcEb08D34d` | 6-of-8 | Ledger signers | (cLabs)
| ChildSafe2 | `0xC03172263409584f7860C25B6eB4985f0f6F4636` | 6-of-8 | Ledger signers | (Council)

## Simulate

```bash
./simulate.sh
```

## Sign & Execute (anvil fork)

```bash
SIGNER_PK=0x... ./execute.sh
```

## Sign & Execute (manual / Ledger)

```bash
just --dotenv-path $(pwd)/.env sign ChildSafe1
just --dotenv-path $(pwd)/.env sign ChildSafe2

SIGNATURES="0x<SIG1>" just --dotenv-path $(pwd)/.env approve ChildSafe1
SIGNATURES="0x<SIG2>" just --dotenv-path $(pwd)/.env approve ChildSafe2

just --dotenv-path $(pwd)/.env execute
```
