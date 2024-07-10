---

# Verilog HDL Projects

Welcome to my Verilog HDL projects repository! This repository contains various projects and code snippets written in Verilog Hardware Description Language (HDL). These projects showcase different digital design concepts and techniques.

## Table of Contents

- [Introduction](#introduction)
- [Projects](#projects)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#License)
- [Contact](#contact)

## Introduction

This repository includes a collection of Verilog HDL projects that I have worked on. Each project demonstrates a specific aspect of digital design, ranging from simple combinational circuits to more complex sequential systems. Verilog is a powerful language used for describing digital systems and is widely used in FPGA and ASIC design.

## Projects

1. **RISC-V Processor**
   - Description: An implementation of a RISC-V processor, a versatile and modular open-source processor architecture.
   - Features:
   - Implementation of the RV32I Instructions in both the single cycle and Pipelined CPU core.
   - Forwarding/Bypassing for Raw Data hazards and Stalling and Flushing Pipeline stages for Branch hazards

2. **Asynchronous FIFO**
   - Description: A First-In-First-Out (FIFO) memory buffer that handles asynchronous read and write operations.
   - Features:- Configurable depth and width, status flags, and clock domain crossing.

3. **SHA-256**
   - Description: An implementation of the SHA-256 cryptographic hash function, which is widely used in security applications.
   - Features: Supports 256-bit hash computation, message padding, and processing.
  
## Getting Started

To get started with any of these projects, clone the repository to your local machine using the following command:

```bash
git clone https://github.com/chetanyed/Projects-HDL.git
```

Navigate to the project directory and follow the instructions 

## Usage

Each project comes with its own testbench and can be simulated with Icarus Verilog and Gtkwave

Here are the cmd line prompts:
```bash
iverilog -o <file_name>.vvp <testbench_file>.v
vvp <file_name>.vvp
gtkwave <vcd_file>.vcd
```

## Contributing

Contributions are welcome! If you have any improvements or new projects to add, please fork the repository, make your changes, and submit a pull request.

## License
This repository is licensed under the MIT License. See the LICENSE file for more information.

## Contact

If you have any questions or suggestions, feel free to reach out to me.

- **Name:** Chetanya Mishra
- **Email:** chetanyamishraa@example.com
- **GitHub:** [Chetanya Mishra](https://github.com/chetanyed)
- **Linkdln** [Chetanya Mishra](www.linkedin.com/in/chetanyamishra)

---
