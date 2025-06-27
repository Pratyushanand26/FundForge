# Crowd Funding Platform Bootcamp — Midterm Submission

Welcome to the midterm submission for the Crowd Funding Platform Bootcamp! Over the past four weeks, I’ve designed, coded a decentralized crowdfunding application on Ethereum using Foundry and Solidity.

---

## 🎯 Project Overview

This platform allows any individual to launch fundraising campaigns with a clear funding goal and deadline. Contributors can pledge ETH, and depending on success:

* If the **funding goal** is met by the **deadline**, the campaign owner can withdraw the collected funds.
* If the **goal is not met**, all contributors can claim refunds.

All core features—campaign creation, contributions, fund withdrawals, refunds, and event logging—are implemented with security best practices like reentrancy protection.

---

## 🌟 Key Features & Learnings

| Week       | Feature                   | Learning Highlights                                                  |
| ---------- | ------------------------- | -------------------------------------------------------------------- |
| **Week 2** | Campaign struct & storage | Defined `Campaign` struct, unique ID counter, mappings               |
| **Week 3** | Contribution function     | Handled `msg.value`, contributor tracking, payable                   |
| **Week 4** | Withdraw & refund logic   | Used `require`, modifiers, `block.timestamp`, pull-over-push pattern |
| **Week 5** | Events & security         | Emitted events, `nonReentrant` guard, low-level `.call`              |

* **Security patterns**: Learned and applied reentrancy guard, integer checks, and proper zeroing before transfers.

---

## 🤝 Collaboration & Mentorship

Throughout the bootcamp, my mentor provided assignments such as:

* Understanding some finance knowledge and the basics of blockchain.
* Learn Solidity.
* Creating the contract,adding functions into it.

All assignment problem statements and my solutions are available in `docs/assignments/` for reference.

---

## 🔮 Next Steps

* Integrate a frontend (React + Ethers.js) to provide a user interface.
* Add gas-optimization and upgradeable patterns (UUPS Proxy).
* Build off-chain indexing with The Graph for real-time campaign dashboards.

> **Thank you** for reviewing my work! I look forward to feedback on solidity best practices and security.
