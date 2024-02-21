# var
MODULE  = $(notdir $(CURDIR))

# version
KERNEL_VER = $(shell uname -r)

# dir
CWD  = $(CURDIR)
BIN  = $(CWD)/bin
INC  = $(CWD)/inc
SRC  = $(CWD)/src
TMP  = $(CWD)/tmp
REF  = $(CWD)/ref
GZ   = $(HOME)/gz

# tool
CURL = curl -L -o
CF   = clang-format

# src
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)
D += $(wildcard src/*.d*)

# all
.PHONY: all
all: fw

.PHONY: qemu
qemu: fw/$(MODULE).iso
	qemu-system-x86_64 \
		-bios /usr/share/ovmf/OVMF.fd -cdrom $<

.PHONY: fw
fw: fw/$(MODULE).iso

ISO_FILES = $(shell find iso -type f)
ISO_FILES += iso/boot/vmlinuz-$(KERNEL_VER)
ISO_FILES += iso/boot/initrd.img-$(KERNEL_VER)

MODS = $(wildcard /boot/grub/x86_64-efi/*.mod)
ISO_FILES += $(subst /boot/grub,iso/boot/grub,$(MODS))

fw/$(MODULE).iso: $(ISO_FILES) Makefile
	-sudo umount tmp/iso
	grub-mkrescue -o $@ iso
	sudo mount $@ tmp/iso -o uid=`whoami`

iso/boot/x86_64-efi/%: /boot/x86_64-efi/%
	cp $< $@
iso/boot/%: /boot/%
	cp $< $@

# format
format: install

# install
.PHONY: install update gz ref
install: doc gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -yu `cat apt.txt`
gz:
ref:
