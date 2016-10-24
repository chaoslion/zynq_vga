#include <stdio.h>
#include <unistd.h>
#include <math.h>
#include "agc.h"
int main() {
	int t,y;
	float x;
	AGC_Color_t col = CBLACK;
	AGC_Graphics_t gfx;
	AGC_Frame_t *frame;

	//INIT
	if( agc_open(&gfx) != AGC_OK ) {
		printf("cant open vga\n");
		return;
	}
	frame = agc_FrameNew();
	if(!frame) {
		printf("no memory for frame\n");
		return;
	}
	//RUN
	while(1) {				
		for(t=0;t<640;t++) {
			x = 100 * sin(2*3.1415*200*t) 
				+ 30 * cos(2*3.1415*10*t) 
				+ 240;
			y = (unsigned int)x;
			frame->pixel[t][y] = col;
			col = (col+1) % CMAX;
		}
		agc_copy_and_park(&gfx,frame);
		agc_FrameClear(frame);
		sleep(1);	
	}
	//CLOSE
	agc_FrameFree(frame);
	agc_close(&gfx);
	return 0;
}