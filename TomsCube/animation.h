/*
 *  animation.h
 *  Cubez
 *
 *  Created by Thomas Bouldin on 11/30/06.
 *  Copyright 2006 Thomas Bouldin. All rights reserved.
 *
 */
#ifndef ANIMATION_H
#define ANIMATION_H

#include "trackball.h"
#define USE_MUTEX 0

typedef enum { 
   ANIM_DRAG_DROP           = 0x1, 
   ANIM_ROTATE              = 0x2, 
   ANIM_TOP_HORIZ_TWIST     = 0x4,
   ANIM_MID_HORIZ_TWIST     = 0x8,
   ANIM_BOTTOM_HORIZ_TWIST  = 0x10,
   ANIM_LEFT_VERT_TWIST     = 0x20,
   ANIM_MID_VERT_TWIST      = 0x40,
   ANIM_RIGHT_VERT_TWIST    = 0x80
} ANIMATION_CLASS;

typedef struct _ANIMATION {
    float quatStart[4];
    float quatStop[4];
    float curQuat[4];
    int   step;
    int   numSteps;
    int  *condition;
    ANIMATION_CLASS type;
    int   shouldDie;
    int   mutex;
    void (*endFunc)(void *param);
    void *param;
} ANIMATION, *PANIMATION;

//void KillActiveAnimations();

void SetSingletonAnimation(ANIMATION_CLASS type, int isSingleton);

void StartAnimation(
    ANIMATION_CLASS type,
    float quatStart[4],
    float quatStop[4],
    long  duration,
    int  *condition,
    void (*endFunc)(void *),
    void *param
    );

/* Gets the current transform matrix for the animation */
/* Although a slight race condition exists, it should not be very important.
 * The only effect is that a few animations might be a step behind a few
 * others */
void GetAnimationMatrix(float mat[4][4], ANIMATION_CLASS types);

void GetAnimationQuat(float quat[4], ANIMATION_CLASS types);
#endif