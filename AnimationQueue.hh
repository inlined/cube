//
//  AnimationQueue.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/15/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import <deque>

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "CubeModel.h"

typedef float Quaternion[4];

typedef struct Animation {
  Quaternion start;
  Quaternion stop;
  Cubelet affectedArea;
  NSTimeInterval duration;
  NSInvocation* doneCallback;
} Animation;

typedef struct AnimationSnapshot {
  Quaternion state;
  Cubelet affectedArea;
} AnimationSnapshot;

//TODO use a wrapper object for synchronization
@interface AnimationQueue : NSObject {
  std::deque<struct Animation> queue;
  NSTimeInterval timeIntoAnimation;
}
- (void)enqueueAnimation:(Animation*)animation;
- (bool)fastFoward:(NSTimeInterval)duration
       forSnapshot:(AnimationSnapshot*)snapshot;
@end
