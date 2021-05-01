# Raspberry Pi Pico Projects

## Setup

Install the following and add to path
- [GNAT Community Edition](https://learn.adacore.com/courses/GNAT_Toolchain_Intro/chapters/gnat_community.html)
- [GNAT Community ARM-ELF](https://www.adacore.com/download)
- [Alire](https://alire.ada.dev/docs/)

Alire is an Ada package manager/library, akin to pip for python.

Run the `setup.sh` script to get dependencies not managed by Alire and link them with Alire. These will be stored in the `deps` directory.

It is sensible to pull the repos cloned into the `deps` every now and again, as they are in continuous development.

## Edit

To edit files in gnatstudio, run the `alr edit` command

run `alr edit --project=<path/to/project.gpr>` where there are more than one project files in the repo.

If you try to open these files in gnatstudio through other means, gnatstudio will not be able to resolve the Alire dependecies and will throw an error.

## Build & Flash

To build the files, run `alr build`. This will create a elf binary that can be loaded onto the pico using its SWD (serial wire debugging) interface.

To use the usb "drag and drop" bootloader, the elf file needs to be converted into uf2, using the elf2uf2 tool provided in the pico-sdk.
