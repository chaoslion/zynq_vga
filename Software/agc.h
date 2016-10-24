#ifndef AGC_H_
#define AGC_H_

#define AGC_DEBUG

#ifdef AGC_DEBUG
#define fail(s) {printf("error: %s\n\r",s);}
#else
#define fail(s) {}
#endif



//SYSTEM 32BIT UNSIGNED INT
typedef long AGC_s32_t;
typedef unsigned long AGC_u32_t;


/*
=============================
AGC DEFINES
=============================
*/
#define AGC_OK 0
#define AGC_FAIL 1

//status register bits
#define AGC_RESET 0x0
#define AGC_FB0EN 0x1
#define AGC_FB1EN 0x3

//farben
#define CBLACK	 	0x0
#define CBLUE 		0x1
#define CGREEN 		0x2
#define CCYAN 		0x3
#define CRED 		0x4
#define CMANGENTA 	0x5
#define CYELLOW 	0x6
#define CWHITE		0x7
#define CMAX		0x8


//adressen aus XPS
//XPS PARAMETERS BEGIN
#define AGC_BRAM_BASE		0x80000000
#define AGC_CONTROLLER_BASE	0x50000000

#define AGC_FRAMEBUFFER0_OFF	0x00000000
#define AGC_FRAMEBUFFER1_OFF	0x00020000
//XPS PARAMETERS END

//frame size
#define AGC_WIDTH 640
#define AGC_HEIGHT 480
// 10 pixels per word
#define AGC_WORD_CNT (AGC_WIDTH*AGC_HEIGHT/10)


//LINUX MEMORY MAP BEGIN
//256kB
#define BRAM_PAGE_SIZE (64*4096)
//4kB
#define CTRL_PAGE_SIZE 4096

//maske um auch adressen an 
//unaligned basisadressen mappen zu koennen
#define BRAM_MASK (BRAM_PAGE_SIZE-1)
#define CTRL_MASK (CTRL_PAGE_SIZE-1)

//LINUX MEMORY MAP END


//struktur um linux gemappte addresse
//zu verwalten
struct MemoryMap_s {
	int fd;
	void* bram_map; //rueckgabe von mmap
	void* ctrl_map;
	void* bram_virt;//virtuelle adresse auf hardware
	void* ctrl_virt;
};
typedef struct MemoryMap_s AGC_MemoryMap_t;


struct Graphics_s {
	AGC_MemoryMap_t memmap;

	//zwei mal bram speicheraddresen, virtuell
	AGC_u32_t* framebuffer[2];
	//status register, virtuell
	AGC_u32_t* ctrl;
	unsigned char active;
};
typedef struct Graphics_s AGC_Graphics_t;


typedef unsigned char AGC_Color_t;


//representiert bild im format BILD(x,y)
//copy_and_park setzt dies in die 10pix/wort speicherung 
//des brams um
struct Frame_s {
	unsigned char id;
	AGC_Color_t pixel[AGC_WIDTH][AGC_HEIGHT];
};
typedef struct Frame_s AGC_Frame_t;


//rechteck
struct Rect_s {
	unsigned int x,y;
	unsigned int w,h;
};

typedef struct Rect_s AGC_Rect_t;




int agc_open( AGC_Graphics_t *agc );
void agc_close( AGC_Graphics_t *agc );

void agc_copy_and_park( AGC_Graphics_t *agc, AGC_Frame_t *frame );
AGC_Frame_t* agc_FrameNew(void);
void agc_FrameFree(AGC_Frame_t *frame);
void agc_FrameClear(AGC_Frame_t *frame);



//2d test mal funktionen 
void agc_drawRect(AGC_Frame_t* frame, unsigned int x, unsigned int y, unsigned int w, unsigned int h, AGC_Color_t clr);
void agc_drawTestPattern(AGC_Frame_t* frame);



#endif /* AGC_H_ */
