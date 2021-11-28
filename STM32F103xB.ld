MEMORY {
    FLASH   (rx) : ORIGIN = 0x08000000, LENGTH = 128K
    RAM    (rwx) : ORIGIN = 0x20000000, LENGTH = 20K

    CCMRAM (rwx) : ORIGIN = 0x10000000, LENGTH = 0K
}

INCLUDE /home/lunar/pros/stm32-examples/common.ld
