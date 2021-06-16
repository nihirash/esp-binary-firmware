SOURCES=$(shell find . -type f -iname "*.asm")
VERSION=$(shell cat version.def)
all: netman

netman: $(SOURCES)
	sjasmplus --sld=main.sld --fullpath netman/main.asm -DV=$(VERSION)
