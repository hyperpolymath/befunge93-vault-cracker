<!--
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025-2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
-->

**A satirical UI that demonstrates esoteric programming absurdity vs.
overengineered security theater.**

<figure>
![JavaScript](https://img.shields.io/badge/language-JavaScript-f7df1e)
</figure>

<figure>
![React](https://img.shields.io/badge/framework-React-61dafb)
</figure>

<figure>
![Deno](https://img.shields.io/badge/runtime-Deno-000000)
</figure>

<figure>
![Satirical](https://img.shields.io/badge/humor-satirical-purple)
</figure>

# Overview

Befunge-93 Vault Cracker is a **parody application** that simulates an
imaginary "attack" on an overengineered cryptographic vault using the
power of [Befunge-93](https://esolangs.org/wiki/Befunge), an esoteric
programming language from 1993 that executes on a 2D grid.

The joke is simple: **no amount of modern cryptography can withstand the
raw power of 1993 innovation.**

## What This Is

- A **satirical UI** mocking both:

  - Overengineered security solutions (Ed448, SHAKE3-256, BLAKE3,
    Kyber-1024, Argon2id, MFA)

  - The absurdity of esoteric programming languages

- A **TEA (The Elm Architecture) demonstration** in JavaScript/React

- A **CSS-first, dependency-free** single-file component

- Built for **screenshots and laughs**, not actual security research

## What This Is NOT

- An actual vault cracker (no real cryptography is harmed)

- A Befunge-93 interpreter (the code is purely decorative)

- Security research or hacking tool

- A serious application

# Quick Start

```bash
# Clone the repository
git clone https://github.com/hyperpolymath/befunge93-vault-cracker
cd befunge93-vault-cracker

# Serve locally (no build step needed - pure JS)
just serve

# Open in browser
open http://localhost:8000
```

# Screenshots

The UI features:

- **Vault Stack Panel** - Shows six "security layers" being "melted" one
  by one

- **Attack Console** - A scrolling log of absurd technical babble

- **Befunge-93 Underpinning** - Decorative ASCII art grid

- **Telemetry Panel** - Fake metrics (Entropy, Latency, Vibes)

# Architecture

## Technology Stack

| Component        | Technology                              |
|------------------|-----------------------------------------|
| Language         | JavaScript (JSX)                        |
| UI Framework     | React                                   |
| State Management | TEA pattern (Model-Update-View)         |
| Styling          | Inline CSS (CSS-first, no dependencies) |
| Runtime          | Deno (for development server)           |

> [!NOTE]
> The source file uses a `.res` extension but contains standard
> JavaScript/JSX. This is intentional parody nomenclature.

## Code Structure

    befunge93-vault-cracker/
    ├── src/
    │   └── Bf93-vault-cracker.res   # Main React component (JavaScript)
    ├── docs/
    │   ├── architecture/            # Architecture documentation
    │   ├── reference/               # Reference documentation
    │   └── CITATIONS.adoc           # Citation formats
    ├── .github/workflows/           # CI/CD workflows
    ├── .machine_readable/           # SCM metadata files
    ├── Justfile                     # Build commands
    └── README.adoc                  # This file

## The "Vault Stack"

The fictional vault being "cracked" consists of:

| Layer | Algorithm         | Satirical Description                     |
|-------|-------------------|-------------------------------------------|
|       | Ed448 Signatures  | "Elliptic curve gravitas"                 |
|       | SHAKE3-256 Sponge | "Absorb fear, squeeze certainty"          |
|       | BLAKE3 Hyperhash  | "Parallel reassurance, artisanal entropy" |
|       | Kyber-1024        | "Post quantum-ish lattice whispering"     |
|       | Argon2id KDF      | "Memory hard, time soft, vibe strong"     |
|       | MFA + Vault       | "Two factors enter, one factor leaves"    |

## The "Attack"

The Befunge-93 "attack" produces absurd log messages like:

- "Injecting BEFUNGE-93 UNDERPINNING…"

- "Reversing control flow with 2D stack topology…"

- "Collapsing MFA into a single factor of irony…"

- "Attempting to typecheck the universe (failed; continue)…"

# Development

## Prerequisites

- [Deno](https://deno.land/) runtime

- [just](https://github.com/casey/just) command runner

## Build Commands

```bash
just serve     # Start development server
just check     # Run all checks
```

## JavaScript Configuration

The project uses vanilla JavaScript with:

- React via CDN (no npm/node dependencies)

- ES6 modules

- Inline CSS (no external stylesheets)

- TEA pattern for state management

# About Befunge-93

[Befunge-93](https://esolangs.org/wiki/Befunge) is an esoteric
programming language created by Chris Pressey in 1993. Key features:

- **2D execution**: The program counter moves on a 2D grid, changing
  direction with `<>^v` commands

- **Self-modifying**: Programs can modify their own source code

- **Stack-based**: All operations work on a LIFO stack

- **80x25 playfield**: Classic terminal dimensions

This project uses Befunge-93 purely as a satirical element. No actual
Befunge code is executed.

# FAQ

## Is this a real security tool?

No. This is purely satirical. No cryptography is actually implemented or
attacked.

## Why Befunge-93?

Because the absurdity of a 1993 esoteric 2D language "defeating" modern
post-quantum cryptography is inherently funny.

## Can I use this for presentations?

Yes! This was designed to be screenshot-friendly and visually
entertaining for talks about:

- Overengineered security solutions

- Esoteric programming languages

- The absurdity of "security theater"

- TEA architecture in JavaScript/React

# Contributing

See <a href="CONTRIBUTING.adoc" class="adoc">CONTRIBUTING</a> for
guidelines.

# License

MPL-2.0

# See Also

- [Befunge-93 on Esolang Wiki](https://esolangs.org/wiki/Befunge)

- [React Documentation](https://react.dev/)

- [The Elm Architecture Guide](https://guide.elm-lang.org/architecture/)
