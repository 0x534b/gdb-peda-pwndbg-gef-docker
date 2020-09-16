# The Original Repo

I did not create this. See the original repo here: https://github.com/apogiatzis/gdb-peda-pwndbg-gef

## Pwndbg + GEF + Peda - In Docker (or anywhere else ig)

This is a script which installs Pwndbg, GEF, and Peda GDB plugins in a single command.

Run `install.sh` and then use one of the commands below to launch the corresponding GDB environment:

```
gdb-peda
gdb-pwndbg
gdb-gef
```

## Installation

Add the following lines to your Dockerfile:

```dockerfile
RUN cd ~ && git clone https://github.com/ksalapatek/gdb-peda-pwndbg-gef-docker.git && \
cd ./gdb-peda-pwndbg-gef-docker && ./install.sh -y
```
