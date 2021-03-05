DEVICE = atmega328p
F_CPU = 16000000
AVR_PROGRAMMER = usbtiny
AVR_PROGRAMMER_PORT = usb

CC = avr-gcc
LD = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

CFLAGS = -mmcu=$(DEVICE) -DF_CPU=$(F_CPU)UL -Wall -O2
LDFLAGS = $(CFLAGS)
AVR_PROGCMD = $(AVRDUDE) -c $(AVR_PROGRAMMER) -P $(AVR_PROGRAMMER_PORT) -p $(DEVICE)

PROGRAM = main.hex

.PHONY: test-programmer
test-programmer:
	$(AVR_PROGCMD) -n -v
	@echo Programmer test passed

.PHONY: program
program: $(PROGRAM)
	$(AVR_PROGCMD) -U flash:w:$(PROGRAM):i

.PHONY: clean
clean:
	$(RM) *.o *.elf *.hex

%.elf: %.o
	$(LD) -s $(LDFLAGS) -o $@ $^

%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $^ $@
