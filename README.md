# Goldcrest Microcode Verification
[![Formal Verification](https://github.com/ics-jku/goldcrest-microcode-verification/actions/workflows/verify.yml/badge.svg?branch=main)](https://github.com/ics-jku/goldcrest-microcode-verification/actions/workflows/verify.yml)

This repository contains the formal verification framework from [here](https://www.ics.jku.at/files/2022FDL_FormalVerificationSUBLEQMicrocode.pdf), which is used to verify the microcode of the [Goldcrest-VP](https://github.com/ics-jku/goldcrest-vp).
The Goldcrest-VP is a RISC-V RV32I Virtual Prototype (VP) which uses a microcoded architecture. The internal microcode is based on just a single instruction, SUBLEQ.

For more information on the Goldcrest-VP or SUBLEQ microcode, you can read the [original paper](https://www.ics.jku.at/files/2022ISVLSI_ExplorationPlatform_RISC-V_OISC.pdf).

## Installation
To run the verification, you need a recent Version of [Racket](https://racket-lang.org/) and the `Rosette` package.
After you installed Racket, Rosette can be downloaded via `raco pkg install rosette`.

If you want to use solvers other than Z3, they have to be installed separately.
For this, follow the instructions of e.g. [Boolector](https://github.com/Boolector/boolector).

## Starting the Verification
To verify one or more microcode procedures, run `racket riscv.rkt [optional bit-width]`, where `bit-width` is 32 if no other value is specified.
To verify additional microcode procedures, uncomment them in `riscv.rkt`.

## Publications
If you want to learn more about SUBLEQ and RISC-V check out our publications about the Goldcrest VP [1] and about how we formally verified the SUBLEQ microcode [2]!

[1] [Lucas Klemmer and Daniel Große. An exploration platform for microcoded RISC-V cores leveraging the one instruction set computer principle. In ISVLSI, 2022.](https://www.ics.jku.at/files/2022ISVLSI_ExplorationPlatform_RISC-V_OISC.pdf)

[2] [Lucas Klemmer, Sonja Gurtner, and Daniel Große. Formal verification of SUBLEQ microcode implementing the RV32I ISA. In FDL, 2022.](https://www.ics.jku.at/files/2022FDL_FormalVerificationSUBLEQMicrocode.pdf)


