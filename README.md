Community Savings Pool

The Community Savings Pool is a Clarity smart contract that enables a group of participants to deposit STX into a shared pool, with funds accessible only by a designated beneficiary. This contract makes community-based saving transparent, secure, and verifiable on-chain.


Features

- Open Deposits — Any user can deposit STX into the shared pool.
- Secure Withdrawals — Only the beneficiary address can withdraw STX.
- Beneficiary Management — The current beneficiary can transfer the role to another user.
- Transparent Balances — View total pool balance and individual contributions.
- Error-Safe Behavior — Prevents unauthorized withdrawals or invalid role transfers.


How It Works

1. Users call `deposit` to add STX to the community pool.
2. Each deposit is recorded under the sender's contribution history.
3. Only the beneficiary can withdraw from the pool using `withdraw`.
4. The beneficiary may transfer the beneficiary role with `set-beneficiary`.
5. Anyone can check:
   - The total pool balance
   - Their personal contribution balance
   - The current beneficiary


Functions Overview

| Function | Type | Description |
|---------|------|-------------|
| `deposit` | Public | Deposit STX into the pool and update contribution record. |
| `withdraw (amount)` | Public | Allows the beneficiary to withdraw a specific amount. |
| `set-beneficiary (new-beneficiary)` | Public | Transfers beneficiary control. |
| `get-total-balance` | Read-Only | Returns total STX stored in the pool. |
| `get-my-contribution` | Read-Only | Returns how much the caller has contributed. |
| `get-beneficiary` | Read-Only | Returns the current beneficiary principal. |

---

Local Development & Testing

This contract is built using:

- Clarity language
- Clarinet for testing

Run tests and validation:

```sh
clarinet check
clarinet test
