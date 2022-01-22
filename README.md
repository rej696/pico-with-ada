# Raspberry Pi Pico Projects
A collection of projects, as well as notes and scripts to help with building, flashing and running ada projects on the Raspberry Pi Pico

## Setup

You can use Docker to build the files, or install everything locally. It is advisable to perform a local install.

### Docker Method
If you use docker to build the files, you will run into problems if you try to edit projects in gnatstudio.

For instructions regarding the installation of docker, see the [Docker Getting Started Guide](https://www.docker.com/get-started)

#### Running the Docker environment.
Run the following command, which downloads and runs the `build.sh` script in an
`ada-builder` container:
```bash
docker run --pull always --rm -t -i -v <Path/To/pico-with-ada>:/build synack/ada-builder:latest ./build.sh
```
This will output object code etc. and an elf2 `main` file to the `obj/` directory.

### Local Machine Installation

_Installation of GNAT Community No longer necessary with Alire_

Install the following and add to path
- ~~[GNAT Community Edition](https://learn.adacore.com/courses/GNAT_Toolchain_Intro/chapters/gnat_community.html)~~
- ~~[GNAT Community ARM-ELF](https://www.adacore.com/download)~~
- [Alire](https://github.com/alire-project/alire)

Alire is an Ada package manager/library, akin to cargo for rust.

#### elf2uf2
To generate .uf2 firmware files, you need to have a copy of the elf2uf2 tool from the pico-sdk in your PATH.

Make sure you have a Native C++ compiler (e.g. g++) compilers. For more
information, see section 2 of the [pico-sdk getting started
guide](https://datasheets.raspberrypi.org/pico/getting-started-with-pico.pdf)

There are two options, install through the pico sdk, or my isolated copy of the
utility. I would recommend to use my version, as it is simpler.

##### Pico-SDK Version
Clone the [pico-sdk](https://github.com/raspberrypi/pico-sdk) to your machine:
```
git clone https://github.com/raspberrypi/pico-sdk
```

Go to the [elf2uf2 tool Directory](https://github.com/raspberrypi/pico-sdk/tree/master/tools/elf2uf2) and build the tool:
```
cd <Installation-Path>/tools/elf2uf2
cmake ./
make -f Makefile
```

##### My elf2uf2 Repository
Clone my [elf2uf2](https://github.com/rej696/elf2uf2) repository, and follow the
instructions in the README there.

##### Add elf2uf2 to path

Regardless of which method used to compile the tool, there now should be an
executable in the directory called `elf2uf2`. This needs to be added to your
path. You can do this on linux by creating a user bin directory, copying the
executable into the new directory, and adding the new directory to your path. On
Windows, you can do a similar thing by creating a directory for user executables
and adding that to your path.
```
mkdir /home/<username>/bin
cp elf2uf2 /home/<username>/bin/
echo "export PATH=$PATH:/home/<username>/bin" >> /home/<username>/.bashrc
source /home/<username>/.bashrc
```

By this point you should now have the `elf2uf2` tool installed on your path. Run
`elf2uf2 -v`. You should see the following:
```
Usage: elf2uf2 (-v) <input ELF file> <output UF2 file>
```

## Editing Files

Run the `alr edit` command to edit files in the project.

To edit files in gnatstudio, you will need to have installed GNAT community
(above).

Alternatively, Alire allows you to set an editor for the `alr edit` command, and
many editors have extensions for the [Ada Language
Server](https://github.com/AdaCore/ada_language_server) which provides for a
very nice code editing experience.

To configure `alr edit`, run `alr help config` to see the configuration options.
Then, run `alr config --global --set editor.cmd "<editor command>"`. For
example, to use vscode, write `alr config --global --set editor.cmd "code
${GPR_FILE}"`. This will open the gpr file of your project in vscode. However,
to open the directory in the workspace, you will have to follow the instructions
in the explorer pane of vscode. To view your modified config, run `alr config
--global`.

run `alr edit --project=<path/to/project.gpr>` where there are more than one
project files in the repo.

If you try to open these files in gnatstudio or some other Ada IDE through other
means, gnatstudio will not be able to resolve the Alire dependencies and will
throw an error.

## Build & Flash

To build the files, run the `alr build` command. This will create a elf binary file.

The `main` elf2 file can then either:
1. Be used with the Pi Pico's SWD (Serial Wire Debug) interface using another Raspberry Pi: see [this blog post for specific instructions](https://synack.me/ada/pico/2021/03/03/from-zero-to-blinky-ada.html), or find more information in [chapter 5 of the Pico Getting Started Guide](https://datasheets.raspberrypi.org/pico/getting-started-with-pico.pdf).
2. Be used with the [pico-debug](https://github.com/majbthrd/pico-debug) repository, which allows debugging and uploading the Pico over usb, so no additional hardware is needed. There are some caveats, look at the repository for more information.
3. Or be converted to .uf2 firmware for uploading via the usb bootloader. [See section 3.2 of the Pico Getting Started Guide](https://datasheets.raspberrypi.org/pico/getting-started-with-pico.pdf)

By far the easiest method is to use the elf2uf2 tool for drag and drop
uploading.

### Flash the pico using `flash.sh`

1. Plug in the pico while holding the `Bootsel` button
2. Ensure the pico is mounted to the correct directory (as specified in the `flash.sh` script)
3. Run `source ./flash.sh <project_name>`

This will convert the elf2 file to uf2, and copy it to the mounted pico. The pico should unmount itself and start running your firmware automatically!

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
For further information and help writing Ada for the Pico, read [the docs for the
pico_bsp](https://pico-doc.synack.me/)

Other helpful links:
- [pico_bsp](https://github.com/JeremyGrosser/pico_bsp)
- [rp2040_hal](https://github.com/JeremyGrosser/rp2040_hal)
- [pico_examples](https://github.com/JeremyGrosser/pico_examples)
- [ada-builder](https://github.com/JeremyGrosser/ada-builder)
- [Jeremy Grosser Blog on RPi Pico Ada Development](https://synack.me)
- [pico_bsp docs](https://pico-doc.synack.me)
- [pico-sdk](https://github.com/raspberrypi/pico-sdk)
