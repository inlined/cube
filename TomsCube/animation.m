/*
 *  animation.c
 *  Cubez
 *
 *  Created by Thomas Bouldin on 11/30/06.
 *  Copyright 2006 Thomas Bouldin. All rights reserved.
 *
 */

#include "animation.h"
#include "trackball.h" /* for quat library */
#include "GraphicsLib.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#define TRUE 1
#define FALSE 0

static PANIMATION *allAnim = NULL;
static int animCapacity = 0;
static int lastAnim = -1;
static float animQuat[4] = {0, 0, 0, 1};
static long animDelay = 15;
static int singletonAnims = 0;
       int killingActiveAnims = 0;

void KillActiveAnimations() {
    int ndx;
    for( ndx = 0; ndx < animCapacity; ndx++ ) {
        if( allAnim[ndx] ) {
            allAnim[ndx]->shouldDie = TRUE;
        }
    }
    killingActiveAnims = TRUE;
}

int DeleteAnimation(int which) {
    if( !allAnim ) {
        fprintf(stderr, "Tried to delete from a non-existent table!\n");
    }
    if( !allAnim[which] ) {
        fprintf(stderr, "Tried to double delete an animation\n");
    }
    
    #if USE_MUTEX
    while( allAnim[which]->mutex )
        ; /* cheap mutex */
    allAnim[which]->mutex = TRUE;
    #endif
    
    free(allAnim[which]);
    allAnim[which] = NULL;
    if( which == lastAnim ) {
        int ndx;
        for(ndx = which - 1; ndx >= 0 && !allAnim[ndx]; ndx-- ) 
            ;
        lastAnim = ndx;
        return TRUE;
    }
    return FALSE;
}
    
void DoAnimation(int which) 
{    
    #if USE_MUTEX
    while( allAnim[which] && allAnim[which]->mutex )
        ;
    allAnim[which]->mutex = TRUE;
    #endif
    
    if( allAnim[which]->shouldDie) {
        if( DeleteAnimation(which) ) {
//            glutPostRedisplay();
        }
        return;
    }
    
    if( allAnim[which]->condition && *(allAnim[which]->condition) ) {
        /* check again in a bit */
        allAnim[which]->mutex = FALSE;
//        glutTimerFunc(animDelay, DoAnimation, which); 
        return;
    }
    
    float t = (float)(allAnim[which]->step++)/allAnim[which]->numSteps;
    int ndx;
    for( ndx = 0; ndx < 4; ndx++ ) {
        allAnim[which]->curQuat[ndx] = allAnim[which]->quatStart[ndx] +
        t * (allAnim[which]->quatStop[ndx] - allAnim[which]->quatStart[ndx]);
    }
    
    /* must give up mutex now, both functions place mutex's */
    allAnim[which]->mutex = FALSE;
    if( allAnim[which]->step <= allAnim[which]->numSteps ) {
//        glutTimerFunc(animDelay, DoAnimation, which); 
    } else {
        if( allAnim[which]->endFunc ) {
            (allAnim[which]->endFunc)(allAnim[which]->param);
        }
        DeleteAnimation(which);
//        glutPostRedisplay();
    }
    
//    glutPostRedisplay();
}

void SetSingletonAnimation(ANIMATION_CLASS type, int isSingleton) {
    if( isSingleton) {
        singletonAnims |= type;
    } else {
        singletonAnims &= ~type;
    }
}

void GetAnimationMatrix(float mat[4][4], ANIMATION_CLASS types) 
{
    GetAnimationQuat(animQuat, types);
    
    build_rotmatrix(mat, animQuat);
}

void GetAnimationQuat(float quat[4], ANIMATION_CLASS types) {
    memset(quat, 0, sizeof(float) * 3);
    quat[3] = 1;

    int ndx;

    for( ndx = 0; ndx < animCapacity; ndx++ ){
        if( NULL != allAnim[ndx] && (allAnim[ndx]->type & types) ) {
            #if USE_MUTEX
            while( allAnim[which] && allAnim[which]->mutex )
                ; /* cheap mutex */
            allAnim[which]->mutex = TRUE;
            #endif
            add_quats(allAnim[ndx]->curQuat, quat, quat);
            allAnim[ndx]->mutex = FALSE;
        } 
    }
    normalize_quat(quat);
}

void StartAnimation(
    ANIMATION_CLASS type,
    float quatStart[4],
    float quatStop[4],
    long  duration,
    int  *condition,
    void (*endFunc)(void *),
    void *param
    )
{    
    killingActiveAnims = FALSE;
    int slot = -1;
    int ndx = -1;
    for( ndx = 0; ndx < animCapacity; ndx++ ) {
        if( allAnim[ndx] && allAnim[ndx]->type == type && (singletonAnims & type) ) {
            allAnim[ndx]->shouldDie = TRUE;
        }
        
        if( !allAnim[ndx] ) {
            slot = ndx;
        }
    }
    
    if( -1 == slot ) {
        PANIMATION *reallocTemp = realloc(allAnim, sizeof(PANIMATION) * animCapacity);
        if( NULL == reallocTemp ) {
            fprintf(stderr, "Out of memory error!\n");
            return;
        }
        
        allAnim = reallocTemp;
        slot = lastAnim = animCapacity++;
    }
    
    if( -1 == lastAnim ) {
        lastAnim = slot;
    }
    
    allAnim[slot] = (PANIMATION) malloc(sizeof(ANIMATION));
    allAnim[slot]->mutex = TRUE;
    memcpy(allAnim[slot]->quatStart, quatStart, sizeof(float) * 4);
    memcpy(allAnim[slot]->curQuat, quatStart, sizeof(float) * 4);
    memcpy(allAnim[slot]->quatStop, quatStop, sizeof(float) * 4);
    allAnim[slot]->type = type;
    allAnim[slot]->numSteps = duration / animDelay;
    allAnim[slot]->step = 0;
    allAnim[slot]->condition = condition;
    allAnim[slot]->shouldDie = FALSE;
    allAnim[slot]->endFunc = endFunc;
    allAnim[slot]->param = param;
    allAnim[slot]->mutex = FALSE;
    
//    glutTimerFunc(animDelay, DoAnimation, slot);
}