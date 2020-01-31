AVR_TOOLCHAIN_PATH = /usr/lib/avr
DEVICE = atmega328p
PROGRAMMER = usbtiny
PROGRAMMER_PORT = usb
F_CPU = 8000000
FUSE_L = 0b11011111
FUSE_H = 0b11011001
CC = avr-gcc
CLANG = clang --target=avr
CFLAGS = -Wall -O2 -mmcu=$(DEVICE) -DF_CPU=$(F_CPU)UL -I$(AVR_TOOLCHAIN_PATH)/include
LLC = llc
LD = avr-gcc
LDFLAGS =

PROGRAM = main.hex

.PHONY: avrdude-test
avrdude-test:
	avrdude -p $(DEVICE) -c $(PROGRAMMER) -P $(PROGRAMMER_PORT) -v
	@echo avrdude test passed

.PHONY: program
program: $(PROGRAM)
	avrdude -p $(DEVICE) -c $(PROGRAMMER) -P $(PROGRAMMER_PORT) -U hfuse:w:$(FUSE_H):m -U lfuse:w:$(FUSE_L):m -U flash:w:$(PROGRAM):i

.PHONY: clean
clean:
	$(RM) *.ll *.o *.elf *.hex

.SUFFIXES:
%.ll: %.c
	$(CLANG) -S $(CFLAGS) -emit-llvm -o $@ $^

%.o: %.ll
	$(LLC) -filetype=obj -o $@ $^

%.elf: %.o
	$(LD) -s $(LDFLAGS) -o $@ $^

%.hex: %.elf
	avr-objcopy -j .text -j .data -O ihex $^ $@
