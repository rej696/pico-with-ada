# Raspberry Pi Pico Projects
A collection of projects, as well as notes and scripts to help with building, flashing and running ada projects on the Raspberry Pi Pico

## Setup

You can use Docker to build the files, or install everything locally. It is advisable to perform a local install.

### Docker Method
If you use docker to build the files, you will run into problems if you try to edit projects in gnatstudio.

For instructions regarding the installation of docker, see the [Docker Getting Started Guide](https://www.docker.com/get-started)

#### Running the Docker environment.
Run the following command, which downloads and runs the `build.sh` script in an `ada-builder` container:
```
docker run --pull always --rm -t -i -v <Path/To/pico-with-ada>:/build synack/ada-builder:latest ./build.sh
```
This will output object code etc. and an elf2 `main` file to the `obj/` directory.

### Local Machine Installation

Install the following and add to path
- [GNAT Community Edition](https://learn.adacore.com/courses/GNAT_Toolchain_Intro/chapters/gnat_community.html)
- [GNAT Community ARM-ELF](https://www.adacore.com/download)
- [Alire](https://alire.ada.dev/docs/)

Alire is an Ada package manager/library, akin to pip for python.

Run the `build.sh` script will also get dependencies not managed by Alire and link them with Alire. These will be stored in the `deps` directory.

It is sensible to pull the repos cloned into the `deps` every now and again, as they are in continuous development.

### elf2uf2
To generate .uf2 firmware files, you need to have a copy of the efl2uf2 tool from the pico-sdk in your PATH.

Make sure you have CMake, Make and Native gcc and g++ compilers. For more information, see section 2 of the [pico-sdk getting started guide](https://datasheets.raspberrypi.org/pico/getting-started-with-pico.pdf)

1. Clone the [pico-sdk](https://github.com/raspberrypi/pico-sdk) to your machine:
```
git clone https://github.com/raspberrypi/pico-sdk
```
2. Go to the [elf2uf2 tool Directory](https://github.com/raspberrypi/pico-sdk/tree/master/tools/elf2uf2) and build the tool:
```
cd <Installation-Path>/tools/elf2uf2
cmake ./
make -f Makefile
```
3. Now there should be an executable in the directory called `elf2uf2`. This needs to be added to your path. You can do this on linux by creating a user bin directory, copying the executable into the new directory, and adding the new directory to your path. On Windows, you can do a similar thing by creating a directory for user executables and adding that to your path.
```
mkdir /home/<username>/bin
cp elf2uf2 /home/<username>/bin/
echo "export PATH=$PATH:/home/<username>/bin" >> /home/<username>/.bashrc
source /home/<username>/.bashrc
```
4. By this point you should now have the `elf2uf2` tool installed on your path. Run `elf2uf2 --v`. You should see the following:
```
Usage: elf2uf2 (-v) <input ELF file> <output UF2 file>
```

## Editing Files

To edit files in gnatstudio, run the `alr edit` command

run `alr edit --project=<path/to/project.gpr>` where there are more than one project files in the repo.

If you try to open these files in gnatstudio through other means, gnatstudio will not be able to resolve the Alire dependecies and will throw an error.

## Build & Flash

To build the files, run the `build.sh` script, or the `alr build` command. This will create a elf binary file.

The `main` elf2 file can then either:
1. Be used with the Pi Pico's SWD (Serial Wire Debug) interface using another Raspberry Pi: see [this blog post for specific instructions](https://synack.me/ada/pico/2021/03/03/from-zero-to-blinky-ada.html), or find more information in [chapter 5 of the Pico Getting Started Guide](https://datasheets.raspberrypi.org/pico/getting-started-with-pico.pdf).
2. Or be converted to .uf2 firmware for uploading via the usb bootloader. [See section 3.2 of the Pico Getting Started Guide](https://datasheets.raspberrypi.org/pico/getting-started-with-pico.pdf)

### Flash the pico using `flash.sh`

1. Plug in the pico while holding the `Bootsel` button
2. Ensure the pico is mounted to the correct directory (as specified in the `flash.sh` script)
3. Run `source ./flash.sh <project_name>`

This will convert the ef2 file to uf2, and copy it to the mounted pico. The pico should unmount itself and start running your firmware automatically!

#### `flash.sh` Modifications
In flash.sh, the target path of the copy command needs to be the location of the Raspberry Pi Pico when mounted in bootloader mode, and you will need to modify the file appropriately. Alternatively, you can forego this script altogether and run the `elf2uf2` tool on the `main` executable, and copy the file manually to the Pico "Drive".

## Troubleshooting
### Cannot Execute Script
If any of the shell scripts in this repo are unable to execute, run the following command, substituting in the name of the script:
```
chmod +x <script_name>.sh
```
This adds execution permissions to the script file. You can achieve the same thing in windows by right clicking the file and modifying its properties such that its executable.

## Links to useful repos and websites
- [pico_bsp](https://github.com/JeremyGrosser/pico_bsp)
- [rp2040_hal](https://github.com/JeremyGrosser/rp2040_hal)
- [pico_examples](https://github.com/JeremyGrosser/pico_examples)
- [ada-builder](https://github.com/JeremyGrosser/ada-builder)
- [Jeremy Grosser Blog on RPi Pico Ada Development](https://synack.me)
- [pico-sdk](https://github.com/raspberrypi/pico-sdk)
