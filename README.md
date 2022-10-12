
pdp11_minecraft
===============================

A PDP-11 emulator for Minecraft.

It runs the Version 6 Unix operating system (1975), the code of which was famously covered by *A Commentary on the Unix Operating System* (1976) by John Lions.

This code is a translation of [Julius Schmidt's PDP-11 emulator][Julius-Schmidt-s-PDP-11-emu] for JavaScript, which you can run in a browser.

## Prerequisites

- [MCC][Command-Block-Assembly] (Minecraft Compiler Collection) v2.0.0 (or later) with [these patches][MCC-patches] applied.
- Make sure [MCC][Command-Block-Assembly] is installed to `/usr/bin/mcc`.

## Usage

### Minecraft world

Use [WorldEdit mod][WorldEdit] to import the [Schematics](schematics) into your Minecraft world.

| Name   | Location        | Size      |
| :----- | :-------------- | :-------- |
| Memory | (15, 124, 15)   | 28x28x128 |
| RK0    | (-43, 124, -43) | 55x55x128 |

### Running

Execute `/function pdp11:init` in game to initialize the emulator, then execute `/function pdp11:run` to start the emulator.

### Stopping

Use `/function pdp11:stop` to stop the emulator, use `/function pdp11:reset` to reset the emulator.

## Note

Unix V6 used `chdir` command instead of `cd`.

Run `stty -lcase` to enable lowercase output.

# See also

- [simon816/Command-Block-Assembly][Command-Block-Assembly], this project offers the high-level language compilers, assembler and Command IR compiler which this project uses.

- [amakukha/PyPDP11][PyPDP11], a successful port of the original JavaScript code for Python 3 with some enhancements which inspired this project.

- [vberlier/nbtlib][nbtlib], a powerful Python library to read and edit NBT data which this project uses to generate Schematics.

[Julius-Schmidt-s-PDP-11-emu]: http://pdp11.aiju.de
[Command-Block-Assembly]: https://github.com/simon816/Command-Block-Assembly
[MCC-patches]: https://gist.github.com/ookiineko/2fdf2a419c98a926d147f5805ba52468
[WorldEdit]: https://enginehub.org/worldedit
[PyPDP11]: https://github.com/amakukha/PyPDP11
[nbtlib]: https://github.com/vberlier/nbtlib
