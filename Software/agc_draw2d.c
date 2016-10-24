#include <stdio.h>
#include <math.h>
#include "agc.h"



void agc_drawRect(AGC_Frame_t* frame, unsigned int x, unsigned int y, unsigned int w, unsigned int h, AGC_Color_t clr) {
	int xp, yp;

	if( x > 640 || y > 480 ) {
		fail("rect: x,y out of bounds");
		return;
	}

	w += x;
	h += y;

	if( w > 640 || h > 480 ) {
		fail("rect: w,h out of bounds");
		return;
	}


	for(yp=y;yp<h;yp++) {
		for(xp=x;xp<w;xp++) {
			frame->pixel[xp][yp] = clr;
		}
	}
}


void rot2d( unsigned int *xp, unsigned int *yp, unsigned int xx, unsigned int yy, float rad ) {

	float x,y;

	x = cos(rad) * (*xp-xx) - sin(rad) *(*yp-yy) + xx;
	y = sin(rad) * (*xp-xx) + cos(rad) * (*yp-yy) + yy;	 
	
	*xp = (unsigned int)x;
	*yp = (unsigned int)y;
}
 
void agc_drawRectRot(AGC_Frame_t *frame, unsigned int x, unsigned int y, unsigned int w, unsigned int h, AGC_Color_t clr,  float r ) {
	unsigned int xi,yi,rx,ry;

	if( x >= 640 ||  y >= 480 )
		fail("x,y out of bounds\n");

	w += x;
	h += y;

	if( w >= 640 || y>=480 )
		fail("w,h out of bounds\n");

	
	for(yi=y;yi<h;yi++) {
		for(xi=x;xi<w;xi++) {
			rx = xi;
			ry = yi;
			rot2d(&rx,&ry,320,240,r);
			if( rx >= 640 || ry >= 480 ) {
				fail("rot x,y out of bounds\n");
			} else { 
				frame->pixel[rx][ry] = clr;
			}		
		}
	}

}




void agc_drawTestPattern(AGC_Frame_t* frame) {
	AGC_Rect_t quad[5];
	int xp, yp,i;
	
	quad[0].x = 0;
	quad[0].y = 0;
	quad[0].w = 100;
	quad[0].h = 100;

	quad[1].x = 200;
	quad[1].y = 0;
	quad[1].w = 300;
	quad[1].h = 100;

	quad[2].x = 100;
	quad[2].y = 100;
	quad[2].w = 200;
	quad[2].h = 200;

	quad[3].x = 0;
	quad[3].y = 200;
	quad[3].w = 100;
	quad[3].h = 300;

	quad[4].x = 200;
	quad[4].y = 200;
	quad[4].w = 300;
	quad[4].h = 300;

	for(yp=0;yp<300;yp++) {
		for(xp=0;xp<300;xp++) {
			frame->pixel[xp][yp] = CBLACK;

			for(i=0;i<5;i++) {
				if( xp >= quad[i].x && xp < quad[i].w && yp >= quad[i].y && yp < quad[i].h )
					frame->pixel[xp][yp] = CWHITE;
			}
		}
	}
}
