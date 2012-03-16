//
//  AnimationQueue.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/15/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import "AnimationQueue.h"

@implementation Animation
@synthesize start;
@synthesize stop;
@synthesize affectedArea;
@synthesize duration;
@synthesize doneCallback;
@end

// Map the linear interpolation to a time bezier curve to give a more physical
// feel (real world objects need to accelerate to a velocity)
// Since this is a touch surface, the sine of the normal mapping will make a
// single hit point on the surface move smoothly which is likely to feel like
// a better touch experience.
float smooth(float t) {
  float s;
  static const float p0 = 0.2;
  static const float p1 = 0.8;
  static const float s0 = 2.0 / (1 + p1 - p0);
  if (t < p0 ) {
    s = t * t * s0 / (2.0 * p0);
  } else if ( t < p1 ) {
    s = ( t - p0 ) * s0 + p0 * s0 / 2;
  } else {
    s = s0 * (p1 - p0) + s0 * p0 / 2 + s0 * (t - p1) * (1 - (t - p1)/(2 * (1 - p1)));
  }

  return sin(s * M_PI_2);
}

@implementation AnimationQueue

- (id)init
{
  self = [super init];
  if (self) {
    queue = [NSMutableArray new];
  }
  return self;
}

- (void)enqueueAnimation:(Animation*)animation
{
  [queue addObject:animation];
}

- (bool)fastFoward:(NSTimeInterval)duration
       forSnapshot:(AnimationSnapshot*)snapshot
{
  if (![queue count]) {
    return NO;
}
  
  timeIntoAnimation += duration;
  Animation* front = [queue objectAtIndex:0];
  while (timeIntoAnimation > front.duration) {
    [queue removeObjectAtIndex:0];
    [front.doneCallback invoke];
    timeIntoAnimation -= front.duration;
    if (![queue count]) {
      timeIntoAnimation = 0;
      return NO;
    }
    front = [queue objectAtIndex:0];
  }
  
  snapshot->affectedArea = front.affectedArea;
  float step = timeIntoAnimation / front.duration;
  snapshot->state = GLKQuaternionSlerp(front.start, front.stop, smooth(step));
  snapshot->state = GLKQuaternionNormalize(snapshot->state);
  return YES;
}

@end
