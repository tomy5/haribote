#define COL8_000000 0
#define COL8_FF0000 1
#define COL8_00FF00 2
#define COL8_FFFF00 3
#define COL8_0000FF 4
#define COL8_FF00FF 5
#define COL8_00FFFF 6
#define COL8_FFFFFF 7
#define COL8_C6C6C6 8
#define COL8_840000 9
#define COL8_008400 10
#define COL8_848400 11
#define COL8_000084 12
#define COL8_840084 13
#define COL8_008484 14
#define COL8_848484 15

extern void io_hlt(void);
//extern void write_mem8(int addr, int data);
extern void io_cli(void);
extern void io_out8(int port, int data);
extern int io_load_eflags(void);
extern void io_store_eflags(int eflags);

void init_pelette(void);
void set_pelette(int start, int end, unsigned char *rgb);
void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);

void HariMain(void)
{
	
	int i; /* 変数宣言。iという変数は、32ビットの整数型 */
	char *p; /* pという変数は、BYTE [...]用の番地 */
	
	init_pelette();
	
	p = (char *) 0xa0000;
	
	boxfill8(p, 320, COL8_FF0000, 20, 20, 120, 120);
	boxfill8(p, 320, COL8_00FF00, 70, 50, 170, 150);
	boxfill8(p, 320, COL8_0000FF, 120, 80, 220, 180);
	/*
	for (i = 0xa0000; i <= 0xaffff; i++) {
		p = (char *)i;
		*p = i & 0x0f;
		// write_mem8(i, i & 0x0f);
		// MOV BYTE [i],15
	}
	*/

	for (;;) {
		io_hlt();
	}
}

void init_pelette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00, // black
		0xff, 0x00, 0x00, // red
		0x00, 0xff, 0x00, // green
		0xff, 0xff, 0x00, // yellow
		0x00, 0x00, 0xff, // blue
		0xff, 0x00, 0xff, // purple
		0x00, 0x00, 0xff, // sky
		0xff, 0xff, 0xff, // white
		0xc6, 0xc6, 0xc6, // gray
		0x84, 0x00, 0x00, // dark red
		0x00, 0x84, 0x00, // dark green
		0x84, 0x84, 0x00, // dark yellow
		0x00, 0x00, 0x84, // dark blue
		0x84, 0x00, 0x84, // dark purple
		0x00, 0x84, 0x84, // dark sky
		0x84, 0x84, 0x84, // dark gray
	};
	set_pelette(0, 15, table_rgb);
	return;
	// static char 命令は、データにしか使えないけどDB命令相当
}

void set_pelette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags(); // 割り込み許可フラグの値を記録する
	io_cli(); // 許可フラグを0にして割り込みを禁止する
	io_out8(0x03c8, start);
	for (i = start; i <= end; i++) {
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags); // 割り込み許可フラグを元に戻す
	return;
}

void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1)
{
	int x, y;
	for (y = y0; y <= y1; y++) {
		for (x = x0; x <= x1; x++) {
			vram[y * xsize + x] = c;
		}
	}
	return;
}
