# 074-opcm-upgrade-v410-celo-sepolia: Sepolia OPCM v4.1.0: Celo Sepolia

Status: [DRAFT]()

## Objective

Executes [Upgrade 16a](https://gov.optimism.io/t/maintenance-upgrade-proposal-u16a/10288) on Sepolia for Celo Sepolia.

## Safe Architecture

| Safe | Address | Threshold | Owners |
|------|---------|-----------|--------|
| Parent (ProxyAdminOwner) | `0x009A6Ac23EeBe98488ED28A52af69Bf46F1C18cb` | 2-of-2 | ChildSafe1, ChildSafe2 |
| ChildSafe1 | `0x769b480A8036873a2a5EB01FE39278e5Ab78Bb27` | 1-of-2 | EOA signers |
| ChildSafe2 | `0x3b00043E8C82006fbE5f56b47F9889a04c20c5d6` | 1-of-2 | EOA signers |

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
