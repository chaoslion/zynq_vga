#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "agc.h"


int agc_open( AGC_Graphics_t *gfx ) {
	AGC_u32_t i;



	if(!gfx) {
		fail("agc_open: gfx is undefined");
		return AGC_FAIL;
	}

	//open /dev/mem
	//fd ist vom typ FILE, mmap braucht ihn
	gfx->memmap.fd = open("/dev/mem", O_RDWR | O_SYNC);
	if( gfx->memmap.fd == -1 ) {
		return AGC_FAIL;
	}

	//mmap gelingt nur wenn speicheradressen
	//aligned im speicher platziert sind
	//allgemein verundet man die adressen mit einer MASK
	//und addiert dann dies auf die gemappte adresse
	
	gfx->memmap.bram_map = mmap(
		0, 
		BRAM_PAGE_SIZE, 
		PROT_READ | PROT_WRITE, 
		MAP_SHARED, 
		gfx->memmap.fd, 
		AGC_BRAM_BASE & ~BRAM_MASK 
	);

	gfx->memmap.ctrl_map = mmap(
		0, 
		CTRL_PAGE_SIZE, 
		PROT_READ | PROT_WRITE, 
		MAP_SHARED, 
		gfx->memmap.fd, 
		AGC_CONTROLLER_BASE & ~CTRL_MASK
	);

	//check map pointer	
	if( gfx->memmap.bram_map == MAP_FAILED || 
		gfx->memmap.ctrl_map == MAP_FAILED ) {
		return AGC_FAIL;
	}

	//set userspace pointers
	gfx->memmap.bram_virt = gfx->memmap.bram_map + 
		(AGC_BRAM_BASE & BRAM_MASK);
	gfx->memmap.ctrl_virt = gfx->memmap.ctrl_map + 
		(AGC_CONTROLLER_BASE & CTRL_MASK);
	
	//initialize gfx structure
	gfx->active = 0;
	gfx->ctrl = 
		(AGC_u32_t*)gfx->memmap.ctrl_virt;


	gfx->framebuffer[0] = 
		(AGC_u32_t*)(gfx->memmap.bram_virt + AGC_FRAMEBUFFER0_OFF);
	gfx->framebuffer[1] = 
		(AGC_u32_t*)(gfx->memmap.bram_virt + AGC_FRAMEBUFFER1_OFF);


	//write disable
	*gfx->ctrl = AGC_RESET;

	//wait a frame
	sleep(1);
	
	//screen is now in reset state

	//clear buffers
	//durch direktes schreiben, darum muss bildschirm
	//im reset sein
	for(i=0;i<AGC_WORD_CNT;i++) {
		gfx->framebuffer[0][i] = 0x0;
		gfx->framebuffer[1][i] = 0x0;
	}

	//enable buffer 0
	//buffer 0 malen
	*gfx->ctrl = AGC_FB0EN;
	return AGC_OK;
}

void agc_close( AGC_Graphics_t *gfx ) {
	if(!gfx) {
		fail("agc_close: gfx undefined");
		return;
	}
	//disable
	*gfx->ctrl = AGC_RESET;
	//unmap
	munmap(gfx->memmap.ctrl_map,CTRL_PAGE_SIZE);
	munmap(gfx->memmap.bram_map,BRAM_PAGE_SIZE);
	close(gfx->memmap.fd);
}

AGC_Frame_t* agc_FrameNew(void) {
	AGC_Frame_t* frame = (AGC_Frame_t*)malloc( sizeof(AGC_Frame_t) );

	if(!frame) {
		fail("agc_FrameNew: no memory for new frame");
		return 0;
	}

	//reset x,y
	agc_FrameClear(frame);

	return frame;
}

void agc_FrameFree(AGC_Frame_t *frame) {
	if(!frame) {
		fail("agc_FrameFree: frame undefined");
		return;
	}
	free(frame);
}

void agc_copy_and_park( AGC_Graphics_t *agc, AGC_Frame_t *frame ) {
	unsigned int i,x,y,word_cnt;
	//get unused buffer
	unsigned char isFB0active;
	AGC_u32_t* target;
	unsigned char co[10];


	if(!agc || !frame) {
		fail("agc_copy_and_park: agc or frame undefined");
		return;
	}

	isFB0active = *agc->ctrl == AGC_FB0EN;

	agc->active = !agc->active;
	target = &agc->framebuffer[ agc->active ][0];
	//copy 2d->1d
	x = 0;
	y = 0;
	i = 0;
	word_cnt = 0;
	
	for(y=0;y<AGC_HEIGHT;y++) {
		for(x=0;x<AGC_WIDTH;x+=10) {
			co[0] = frame->pixel[x][y];
			co[1] = frame->pixel[x+1][y];
			co[2] = frame->pixel[x+2][y];
			co[3] = frame->pixel[x+3][y];
			co[4] = frame->pixel[x+4][y];
			co[5] = frame->pixel[x+5][y];
			co[6] = frame->pixel[x+6][y];
			co[7] = frame->pixel[x+7][y];
			co[8] = frame->pixel[x+8][y];
			co[9] = frame->pixel[x+9][y];		
			
			target[word_cnt] = co[0] << 29
							| co[1] << 26 
							| co[2] << 23
							| co[3] << 20
							| co[4] << 17
							| co[5] << 14
							| co[6] << 11
							| co[7] << 8
							| co[8] << 5
							| co[9] << 2;
			word_cnt++;	
		}
	}
	

	//write to register
	if( isFB0active ) {
		*agc->ctrl = AGC_FB1EN;
	} else {
		*agc->ctrl = AGC_FB0EN;
	}
}

void agc_FrameClear(AGC_Frame_t *frame) {
	int x,y;

	memset(frame,0,sizeof(AGC_Frame_t));
	/*
	for(y=0;y<AGC_HEIGHT;y++) {
		for(x=0;x<AGC_WIDTH;x++) {
			frame->pixel[x][y] = CBLACK;
		}
	}
	*/
}



