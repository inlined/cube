//
//  AnimationQueue.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/15/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import "AnimationQueue.h"
#import "TrackballGestureRecognizer.h"
#import "CubeView.hh"
#import "NSInvocation+Shorthand.h"

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
    mutex = dispatch_queue_create("com.espressobytes.animation_queue", NULL);
  }
  return self;
}

- (void)dealloc
{
  dispatch_release(mutex);
}

- (void)SetUpTrackballTrackingWithView:(CubeView*) aView
{
  self->view = aView;
  TrackballGestureRecognizer *recognizer = 
  [[TrackballGestureRecognizer alloc]
   initWithTarget:self
   action:@selector(handleDrag:)];
  [recognizer setDelegate:self];
  recognizer.minimumNumberOfTouches = 2;
  recognizer.maximumNumberOfTouches = 2;
  [aView.scene.view addGestureRecognizer:recognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch 
{
  // TODO: Filter out black touches
  return YES;
}

- (Animation *) finalizeDragAnimation:(TrackballGestureRecognizer *) recognizer
{
  Animation *animation =[Animation new];
  animation.affectedArea = WHOLE_CUBE;
  animation.start = recognizer.currentRotation;
  animation.duration = 0.2;
  
  CGPoint velocity = recognizer.currentVelocity;
  if (velocity.x < -4) {
    animation.stop = GLKQuaternionMakeWithAngleAndAxis(M_PI_2, 0, -1, 0);
    animation.doneCallback = 
    [NSInvocation invocationWithTarget:view
                              selector:@selector(rotateModel:)
                       retainArguments:NO, ROT_LEFT];
  } else if (velocity.x > 4) {
    animation.stop = GLKQuaternionMakeWithAngleAndAxis(M_PI_2, 0, 1, 0);
    animation.doneCallback = 
    [NSInvocation invocationWithTarget:view
                              selector:@selector(rotateModel:)
                       retainArguments:NO, ROT_RIGHT];
  } else if (velocity.y < -4) {
    animation.stop = GLKQuaternionMakeWithAngleAndAxis(M_PI_2, 1, 0, 0);
    animation.doneCallback = 
    [NSInvocation invocationWithTarget:view
                              selector:@selector(rotateModel:)
                       retainArguments:NO, ROT_DOWN];
  } else if (velocity.y > 4) {
    animation.stop = GLKQuaternionMakeWithAngleAndAxis(M_PI_2, -1, 0, 0);
    animation.doneCallback = 
    [NSInvocation invocationWithTarget:view
                              selector:@selector(rotateModel:)
                       retainArguments:NO, ROT_UP];
  } else {
    animation.stop = GLKQuaternionIdentity;
  }
  return animation;
}

- (void)handleDrag:(TrackballGestureRecognizer *)gestureRecognizer
{
  if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    Animation *animation = [self finalizeDragAnimation:gestureRecognizer];

    NSLog(@"Quat correct %@ -> %@",
          NSStringFromGLKQuaternion(animation.start),
          NSStringFromGLKQuaternion(animation.stop));
    
    dispatch_sync(mutex, ^{
      self->_isDragging = NO;
      [queue insertObject:animation atIndex:0];
    });
  } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
    NSLog(@"Gesture quat: %@", NSStringFromGLKQuaternion(gestureRecognizer.currentRotation));
    dispatch_sync(mutex, ^{
      _isDragging = YES;
      _dragState.affectedArea = WHOLE_CUBE;
      _dragState.state = [gestureRecognizer currentRotation];
    });
  }
}

- (void)enqueueAnimation:(Animation*)animation
{
  dispatch_sync(mutex, ^{
    [queue addObject:animation];
  });
}

- (bool)fastFoward:(NSTimeInterval)duration
       forSnapshot:(AnimationSnapshot*)snapshot
{
  __block bool queueEmpty = NO;
  __block Animation* front = nil;
  __block bool isDragging = NO;
  
  // Try peek
  dispatch_sync(mutex, ^{
    if (_isDragging) {
      *snapshot = _dragState;
      isDragging = YES;
    }
    if ([queue count]) {
      queueEmpty = NO;
      front = [queue objectAtIndex:0];
    } else {
      queueEmpty = YES;
    }
  });
  
  if (isDragging) { return YES; }
  if (queueEmpty) {
    return NO;
  }
  
  timeIntoAnimation += duration;
  while (timeIntoAnimation > front.duration) {
    [front.doneCallback invoke];
    timeIntoAnimation -= front.duration;
    
    // pop, try peek
    dispatch_sync(mutex, ^{
      [queue removeObjectAtIndex:0];
      if ([queue count]) {
        queueEmpty = NO;
        front = [queue objectAtIndex:0];
      } else {
        queueEmpty = YES;
      }
    });
    
    if (queueEmpty) {
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
