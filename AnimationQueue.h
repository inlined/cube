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
@interface AnimationQueue : NSObject {
  NSMutableArray* queue;
  NSTimeInterval timeIntoAnimation;
}
- (void)enqueueAnimation:(Animation*)animation;
- (bool)fastFoward:(NSTimeInterval)duration
       forSnapshot:(AnimationSnapshot*)snapshot;
@end
