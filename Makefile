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
hankaku.o : hankaku.c
	$(CC) -c -march=i486 -m32 -fno-pic -nostdlib hankaku.c
dsctbl.o : dsctbl.c
	$(CC) -c -march=i486 -m32 -fno-pic -nostdlib dsctbl.c
graphic.o : graphic.c
	$(CC) -c -march=i486 -m32 -fno-pic -nostdlib graphic.c

bootpack.hrb : bootpack.c har.ld naskfunc.o hankaku.o dsctbl.o graphic.o Makefile
	$(CC) -W -march=i486 -m32 -fno-pic -nostdlib -T har.ld bootpack.c *.o -o bootpack.hrb

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

# Tool
fconv : font_convert.c
	gcc -o font_convert.c font_convert

makefont : makefont.c
	gcc -o makefont.c makefont

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
	# Tool
	rm -f makefont
	rm -f font_convert
