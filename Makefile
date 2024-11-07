MCU = atmega2560
F_CPU = 16000000UL
BAUD = 115200

PROGRAMMER = wiring
PORT = /dev/cu.usbmodem1101

CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size

CFLAGS = -Os -DF_CPU=$(F_CPU) -mmcu=$(MCU) -Wall -Wextra
LDFLAGS = -mmcu=$(MCU)

SRC = kernel.c
OBJ = $(SRC:.c=.o)
TARGET = kernel

all: $(TARGET).hex size

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET).elf: $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $^

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

size: $(TARGET).elf
	$(SIZE) --format=avr --mcu=$(MCU) $<

flash: $(TARGET).hex
	avrdude -v -p $(MCU) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -D -U flash:w:$<:i

clean:
	rm -f $(TARGET).hex $(TARGET).elf $(OBJ)

.PHONY: all clean flash size
