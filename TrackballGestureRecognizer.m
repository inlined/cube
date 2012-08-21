//
//  TrackballGestureRecognizerr.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/31/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import "TrackballGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "trackball.h"

bool AreClose(float a, float b) {
  return abs(a - b) < 0.01;
}

CGPoint firstPoint;
@implementation TrackballGestureRecognizer

@synthesize currentRotation;
@synthesize currentVelocity;

- (id)initWithTarget:(id)aTarget selector:(SEL)selector
{
  if (self = [super initWithTarget:aTarget action:selector]) {
    currentRotation = GLKQuaternionIdentity;
  }
  return self;
}

-(CGPoint) centroidOfTouches:(NSSet *)touches {
  NSArray *all = [touches allObjects];
  int count = [all count];
  CGPoint point = CGPointMake(0, 0);
  for (int i = 0; i < count; ++i) {
    CGPoint delta = [[all objectAtIndex:i] locationInView:self.view];
    point.x += delta.x;
    point.y += delta.y;
  }
  point.x /= count;
  point.y /= count;
  return point;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesBegan:touches withEvent:event];
  firstPoint = [self normalize:[self centroidOfTouches:touches]];
  NSLog(@"Touches began");
  self.currentRotation = GLKQuaternionIdentity;
}

- (CGPoint)normalize:(CGPoint)point {
  CGSize size = self.view.bounds.size;
  CGPoint result;
#if ASPECT_CORRECTION
  if (size.width < size.height) {
    float excess = (size.height - size.width) / 2;
    result = CGPointMake(-1 + 2.0 * (point.x / size.width),
                         1 - 2.0 * ((point.y - excess) / size.width));
  } else {
    float excess = (size.width - size.height) / 2;
    result = CGPointMake(-1 + 2.0 * ((point.x - excess) / size.height),
                         1 - 2.0 * (point.y / size.height));
  }
#else
  result = CGPointMake(-1 + 2.0 * (point.x / size.width),
                       1 - 2.0 * (point.y / size.height));
#endif
  
  return result;

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesMoved:touches withEvent:event];
  
  // Must always track velocity or it will be wrong when one finger lifts before
  // the other.
  self.currentVelocity = [self normalize:[self velocityInView:self.view]];
  
  // Sometimes iOS drops a finger; quit lest we jitter
  if ([touches count] < self.minimumNumberOfTouches ||
      [touches count] > self.maximumNumberOfTouches) {
    return;
  }
  if (self.state != UIGestureRecognizerStateChanged) {
    firstPoint = [self normalize:[self centroidOfTouches:touches]];
    return;
  }
  
  CGPoint p2 = [self normalize:[self centroidOfTouches:touches]];
  float theta = atan((p2.x - firstPoint.x) * 4);
  float phi = atan((p2.y - firstPoint.y) * 4);
  
  self.currentRotation = GLKQuaternionAdd(
      GLKQuaternionMakeWithAngleAndAxis(theta, 0, 1, 0),
      GLKQuaternionMakeWithAngleAndAxis(-phi, 1, 0, 0));
  
  /*
  GLfloat lastquat[4];  
  trackball(lastquat, p2.x, p2.y, p1.x, p1.y);
  GLKQuaternion macquat = GLKQuaternionMakeWithArray(lastquat);
  NSLog(@"Rep of quaternion PI @ <0, 0, 1> is %@",
        NSStringFromGLKQuaternion(GLKQuaternionNormalize(GLKQuaternionMakeWithAngleAndAxis(M_PI_2, 0, 0, 0.25))));
  NSLog(@"Adding quaternion %@", NSStringFromGLKQuaternion(macquat));

  self.currentRotation = GLKQuaternionAdd(self.currentRotation, macquat);*/
}

/*
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"Touched ended");
  [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"WTF? Touches cancelled..");
  self.state = UIGestureRecognizerStateCancelled;
}*/

- (void)reset
{
  NSLog(@"Reset");
  //  self.currentRotation = GLKQuaternionIdentity;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
  return [super canBePreventedByGestureRecognizer:preventingGestureRecognizer];
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
  return [super canPreventGestureRecognizer:preventedGestureRecognizer];
}

@end
