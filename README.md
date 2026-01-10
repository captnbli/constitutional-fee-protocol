# Constitutional Fee Protocol (Demo)

A minimal, **forkable** reference implementation of a “constitutional” protocol fee that **decreases automatically with global protocol volume**, enforced in code.

This repository is intended to be a starting point for discussion and experimentation (e.g. on ethresear.ch), not a production-ready fundraising or payments system.

You can read the [Motivation](Motivation.md) for this project

And the [Engineering Perspecive is here](Motivation.md) 

## What this is

- A Solidity fee model where the protocol fee is a deterministic function of **global trailing volume**.
- The fee is **bounded**:
  - starts at `f_max`
  - decays with adoption (global volume)
  - approaches a non-zero floor `f_min` for sustainability
- A minimal ERC20 “donation intake” contract demonstrating how the fee would be applied, with an **auditable event log**.

### Fee function (alpha = 1 power-law)

Let `V` be trailing global protocol volume (e.g., trailing 90 days), and `V0` be a scale parameter.

```
f(V) = f_min + (f_max - f_min) * V0 / (V0 + V)
```

This is the α=1 special case of:

```
f(V)=f_min + (f_max-f_min)/ (1+V/V0)^alpha
```

…and is “logarithmic” in the sense that the log of the excess fee is linear in `log(1 + V/V0)`.

## What this is not

- No token.
- No DAO.
- No yield.
- No governance knobs for fees in this demo.
- No claim this solves compliance, KYC, fraud, or payout rails (e.g. M-PAiSA) — those are separate layers.

## Repository layout

- `contracts/`
  - `FeeModel.sol` – pure fee math (BPS + power-law decay)
  - `ConstitutionalFeeOracle.sol` – immutable parameters and fee computation
  - `DonationIntake.sol` – sample intake applying the fee
  - `MockGlobalVolumeOracle.sol` – **testing-only** oracle (mutable; not constitutional)
- `test/` – Hardhat tests
- `scripts/` – example deployment script

## Quick start

### Prerequisites
- Node.js 18+ (or 20+)
- npm

### Install
```bash
npm install
```

### Compile
```bash
npm run build
```

### Test
```bash
npm test
```

## Design notes

### “Global trailing volume” oracle
A real system needs a robust definition of `V` (trailing volume), and a credible way to compute it.

This demo includes `MockGlobalVolumeOracle` so tests and examples work. In production, you would replace it with something like:
- on-chain rolling volume buckets (if all flows are on-chain), or
- attested aggregates from payment/payout adapters (if many flows originate off-chain), with clear constitutional rules for exclusions (refunds, reversals, wash volume).

### Credible neutrality & enforcement
The purpose of this approach is to make fee extraction:
- transparent
- bounded
- predictable
- difficult to quietly change

In a live protocol, **hard forks** (social consensus) are the enforcement mechanism if the constitution must change.

## License
MIT. See `LICENSE`.

## Disclaimer
This code is provided for educational and research discussion purposes only. It has not been audited and is not intended for production use.
