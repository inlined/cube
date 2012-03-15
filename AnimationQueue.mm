//
//  AnimationQueue.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/15/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import "AnimationQueue.hh"
#include "trackball.h"

void scale(float s, Quaternion q, Quaternion result) {
  result[0] = q[0] * s;
  result[1] = q[1] * s;
  result[2] = q[2] * s;
  result[3] = q[3] * s;
}

void add(Quaternion left, Quaternion right, Quaternion result) {
  result[0] = left[0] + right[0];
  result[1] = left[1] + right[1];
  result[2] = left[2] + right[2];
  result[3] = left[3] + right[3];
}

void normalize(Quaternion result)
{
  float mag = sqrt(
      result[0] * result[0] +
      result[1] * result[1] +
      result[2] * result[2] +
      result[3] * result[3]);
  scale(1 / mag, result, result);
}

void lerp(Quaternion from, Quaternion to, float fraction, Quaternion result) {
  scale(1 - fraction, to, result);
  add(from, result, result);
  normalize(result);
}


@implementation AnimationQueue

- (void)enqueueAnimation:(Animation*)animation
{
  queue.push_back(*animation);
}

- (bool)fastFoward:(NSTimeInterval)duration
       forSnapshot:(AnimationSnapshot*)snapshot
{
  if (queue.empty()) {
    return NO;
  }
  
  timeIntoAnimation += duration;
  struct Animation* front = &queue.front();
  while (timeIntoAnimation >= front->duration) {
    [front->doneCallback invoke];
    timeIntoAnimation -= front->duration;
    queue.pop_front();
    if (queue.empty()) {
      return NO;
    }
  }
  
  snapshot->affectedArea = front->affectedArea;
  float step = front->duration / timeIntoAnimation;
  lerp(front->start, front->stop, step, snapshot->state);
  
  return YES;
}

@end
