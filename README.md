## About
This is a sample repository for working with `avr-gcc` and `avrdude` on simple Atmel projects.

## Usage
`make program`

to build and upload `main.hex`, which is built from `main.c`.

You can change the `TARGET` variable to build/upload another program:

`make TARGET=blink program`
