/*
 *  GraphicsLib.h
 *  First introduced in Proj1
 *
 *  Created by Thomas Bouldin on 10/9/06.
 *  From code by Dr. Buckalew of Cal Poly University
 *  Commonly used functions & variables.
 *
 */
#ifndef GRAPHICS_LIB
#define GRAPHICS_LIB

#include <math.h>
#include <stdio.h>

#define PI M_PI

#define RAD_TO_DEG(ang) ( (ang) * 180.0 / PI )

void normalize(float[3]);
void normCrossProd(float[3], float[3], float[3]);
void keyCallback(int key, int x, int y);
void mouseCallback(int button, int state, int x, int y);
void dragCallback(int x, int y);
void reshapeCallback(int w, int h);
void setUpView();
void setUpModelTransform();
void setUpLight();
void rotate();
void RotateTrackBall();
void display();

#endif