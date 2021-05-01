#!/bin/bash

mkdir deps;
cd deps;
git clone --depth=1 https://github.com/JeremyGrosser/rp2040_hal;
git clone --depth=1 https://github.com/JeremyGrosser/pico_bsp;

cd ..;
alr -n pin -f --use=deps/pico_bsp pico_bsp;
alr -n pin -f --use=deps/rp2040_hal rp2040_hal;
alr build;
