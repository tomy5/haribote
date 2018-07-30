extern void io_hlt(void);
//extern void write_mem8(int addr, int data);

void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

void init_pelette(void);
void set_pelette(int start, int end, unsigned char *rgb);

void HariMain(void)
{
	
	int i; /* 変数宣言。iという変数は、32ビットの整数型 */
	char *p; /* pという変数は、BYTE [...]用の番地 */
	
	//init_pelette();
	
	p = (char *) 0xa0000;
	
	for (i = 0xa0000; i <= 0xaffff; i++) {
		p = (char *)i;
		*p = i & 0x0f;
		//write_mem8(i, i & 0x0f);
		/* MOV BYTE [i],15 */
	}

	for (;;) {
		io_hlt();
	}
}
/*
void init_pelette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00, // black
		0xff, 0x00, 0x00, // red
		0x00, 0xff, 0x00, // green
		0xff, 0xff, 0x00, // yellow
		0x00, 0x00, 0xff, // blue
		0xff, 0x00, 0xff, // 紫
		0x00, 0x00, 0xff, // sky
		0xff, 0xff, 0xff, // white
		0xc6, 0xc6, 0xc6, // gray
	};
	set_pelette(0, 7, table_rgb);
	return;
	// static char 命令は、データにしか使えないけどDB命令相当
}

void set_pelette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags();
	io_cli();
	io_out8(0x03c8, start);
	for (i = start; i <= end; i++) {
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rbf += 3;
	}
	io_store_eflags(eflags);
	return;
}
*/
