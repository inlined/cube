//
//  AnimationQueue.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/15/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "CubeEnums.h"
#import "TrackballGestureRecognizer.h"

@class CubeView;

@interface Animation : NSObject
@property (assign, nonatomic) GLKQuaternion start;
@property (assign, nonatomic) GLKQuaternion stop;
@property (assign, nonatomic) Cubelet affectedArea;
@property (assign, nonatomic) NSTimeInterval duration;
@property (strong, nonatomic) NSInvocation* doneCallback;
@end

typedef struct AnimationSnapshot {
  GLKQuaternion state;
  Cubelet affectedArea;
} AnimationSnapshot;

//TODO use a wrapper object for synchronization
@interface AnimationQueue : NSObject <UIGestureRecognizerDelegate> {
  NSMutableArray* queue;
  NSTimeInterval timeIntoAnimation;
  dispatch_queue_t mutex;
  
  bool _isDragging;
  AnimationSnapshot _dragState;
  CubeView* view;
}

- (void)SetUpTrackballTrackingWithView:(CubeView*)target;
- (void)handleDrag:(TrackballGestureRecognizer*)recognizer;
- (void)enqueueAnimation:(Animation*)animation;
- (bool)fastFoward:(NSTimeInterval)duration
       forSnapshot:(AnimationSnapshot*)snapshot;
@end
