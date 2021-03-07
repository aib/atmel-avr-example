DEVICE = atmega328p
F_CPU = 16000000
AVR_PROGRAMMER = usbtiny
AVR_PROGRAMMER_PORT = usb

TARGET = main
SRC = $(TARGET).c

CC = avr-gcc
LD = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

CFLAGS = -mmcu=$(DEVICE) -DF_CPU=$(F_CPU)UL -Wall -O2
LDFLAGS = $(CFLAGS)
AVR_PROGCMD = $(AVRDUDE) -c $(AVR_PROGRAMMER) -P $(AVR_PROGRAMMER_PORT) -p $(DEVICE)

.PHONY: all
all: $(TARGET).hex
	@echo "Use target 'program' to program (or 'test-programmer')"

.PHONY: test-programmer
test-programmer:
	$(AVR_PROGCMD) -n -v
	@echo "Programmer test passed"

.PHONY: program
program: $(TARGET).hex
	$(AVR_PROGCMD) -U flash:w:$(TARGET).hex:i

.PHONY: clean
clean:
	$(RM) *.o *.elf *.hex

$(TARGET).elf: $(SRC:.c=.o)
	$(LD) -s $(LDFLAGS) -o $@ $^

%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $^ $@
