CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

SYS_FILE_PREFIX = /home/lunar/pros/stm32-examples

SRC ?=
SRC += $(SYS_FILE_PREFIX)/FWlib/src/*.c
SRC += $(SYS_FILE_PREFIX)/CMSIS/*.c
SRC += $(SYS_FILE_PREFIX)/STM32F103xB.s

DEVICE = STM32F10X_MD
LK_SCRIPT = $(SYS_FILE_PREFIX)/STM32F103xB.ld

# define some gcc flags
CFLAGS = -specs=nosys.specs
CFLAGS += -D$(DEVICE)
CFLAGS += -T$(LK_SCRIPT)
CFLAGS += -g

INC_DIR ?= 
INC_DIR += $(SYS_FILE_PREFIX)/FWlib/inc
INC_DIR += $(SYS_FILE_PREFIX)/CMSIS

CFLAGS += $(addprefix -I, $(INC_DIR))

# machine-dependant options
SERIES_CPU = cortex-m3
SERIES_ARCH = armv7-m

CFLAGS += -mcpu=$(SERIES_CPU)
CFLAGS += -march=$(SERIES_ARCH)
CFLAGS += -mlittle-endian
CFLAGS += -mthumb
CFLAGS += -masm-syntax-unified
CFLAGS += -Wimplicit-function-declaration

ifndef PROJ_NAME
	$(error please define your project name)
endif

HEX_FILE = $(PROJ_NAME).hex
ELF_FILE = $(PROJ_NAME).elf


all: $(HEX_FILE)

$(HEX_FILE): $(ELF_FILE)
	$(OBJCOPY) -O ihex $^ $@

$(ELF_FILE): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@

# serial port burning
burn: $(HEX_FILE)
	sudo stm32flash -w $^ /dev/ttyUSB0
