MAKE     = make
NASM     = nasm
CC      = gcc

# デフォルト動作

default :
	$(MAKE) img

# ファイル生成規則

ipl10.bin : ipl10.asm Makefile
	$(NASM) -o ipl10.bin ipl10.asm

asmhead.bin : asmhead.asm Makefile
	$(NASM) -o asmhead.bin asmhead.asm

naskfunc.o : naskfunc.asm Makefile
	$(NASM) -f elf naskfunc.asm -o naskfunc.o

bootpack.hrb : bootpack.c har.ld naskfunc.o Makefile
	$(CC) -march=i486 -m32 -fno-pic -nostdlib -T har.ld bootpack.c naskfunc.o -o bootpack.hrb

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

# コマンド

img :
	$(MAKE) haribote.img
	@echo "Image creantion succeeded."

run :
	$(MAKE) img
	qemu-system-i386 -fda haribote.img

clean :
	rm -f *.bin
	rm -f *.sys
	rm -f *.img
	rm -f *.hrb
	rm -f *.o
