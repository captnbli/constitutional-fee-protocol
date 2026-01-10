# Motivation

Crowdfunding platforms such as GoFundMe have enabled extraordinary acts of generosity. They make it possible for people to respond quickly and directly to need, often in moments of crisis. That is a genuine public good.

At the same time, these platforms necessarily charge fees. Some of those fees are fixed, some are variable, and some are opaque to donors at the moment of giving. Even when the headline percentage looks modest, at scale the total amount retained by the platform can become substantial — particularly as campaigns and platforms grow more successful.

This repository explores a simple question:

> **What would a transparent fee model look like where success benefits donors and beneficiaries, rather than increasing rent extraction by the platform?**

---

## The problem being addressed

The issue is not that platforms charge fees. Sustainable infrastructure costs money to build and maintain.

The issue is what happens **as adoption grows**.

In most centralised platforms:

- Costs per transaction fall as scale increases.
- Revenues rise faster than costs.
- Fees remain flat or become a source of increasing rent extraction.
- Success primarily benefits the platform, not the participants.

This creates a structural imbalance between:

- the people who give,
- the people who receive,
- and the infrastructure that sits between them.

---

## The idea behind the Constitutional Fee Protocol

The Constitutional Fee Protocol proposes a different rule:

> **As a platform succeeds and economies of scale improve, fees should fall — not become a growing source of rent.**

Instead of treating scale as an opportunity to extract more, this protocol treats scale as a reason to **share efficiency gains**.

In practical terms, the protocol explores:

### Declining fee curves

Fees are allowed to cover real operating costs, but as usage grows and per-transaction costs fall, the fee rate automatically reduces.

### Explicit upper limits

Fees cannot silently creep upward as a percentage of funds raised. Any maximum is visible, fixed by rule, and enforceable.

### Transparent handling of surplus

If contributions exceed what is required to operate the system, the excess is not quietly absorbed. It is handled according to predefined, visible rules — for example:

- returned proportionally to donors,
- directed to shared infrastructure or public goods,
- or allocated to future development with explicit consent.

### Rules enforced by code, not discretion

The fee logic is embedded in smart contracts. It cannot be changed unilaterally, retroactively, or without visibility.

---

## What this is — and is not

This project is **not**:

- an attack on GoFundMe or similar platforms,
- a claim that current platforms act in bad faith,
- or a promise of zero-fee crowdfunding.

It **is**:

- an exploration of how economies of scale can benefit participants rather than intermediaries,
- a demonstration of how fee structures can be constitutionally constrained,
- and an attempt to show that sustainability and fairness do not have to be in tension.

---

## Why this matters

Crowdfunding often operates in moments of urgency, grief, or solidarity. In those moments, people give because they want to help — not because they have evaluated a platform’s long-term incentive structure.

A fee model where success automatically reduces costs for users ensures that:

- trust does not depend on goodwill alone,
- incentives remain aligned as the platform grows,
- and success benefits the many, not just the intermediary.

This repository exists to make those ideas concrete, inspectable, and open to critique.
