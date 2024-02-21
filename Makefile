# var
MODULE  = $(notdir $(CURDIR))

# version

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
all: fw/$(MODULE).iso

.PHONY: qemu
qemu: fw/$(MODULE).iso
	qemu-system-x86_64 -cdrom $<

ISO_FILES = $(shell find iso -type f)
fw/$(MODULE).iso: $(ISO_FILES) Makefile
	-sudo umount tmp/iso
	grub-mkrescue -o $@ iso
	sudo mount $@ tmp/iso -o uid=`whoami`

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
