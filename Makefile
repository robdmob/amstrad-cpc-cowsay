TARGET=cowsay
AS=rasm
ASFLAGS= -eo

$(TARGET): $(TARGET).asm
	$(AS) $(ASFLAGS) $<

