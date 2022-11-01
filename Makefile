TARGET=cowsay
AS=rasm
ASFLAGS= -eo

VERSION = $(subst ., ,$(subst v,,$(shell git describe --abbrev=0 --tags)))

MARK = $(word 1, $(VERSION))
VERS = $(word 2, $(VERSION))
MODI = $(word 3, $(VERSION))

ASFLAGS += -DROM_MARK=$(MARK) -DROM_VERS=$(VERS) -DROM_MODI=$(MODI)

$(TARGET): $(TARGET).asm
	$(AS) $(ASFLAGS) $<

