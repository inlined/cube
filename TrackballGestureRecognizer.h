//
//  TrackballTracker.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/31/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import <GLKit/GLKit.h>

@class TrackballGestureRecognizer;

@interface TrackballGestureRecognizer : UIPanGestureRecognizer

@property (atomic, assign) GLKQuaternion currentRotation;
@property (atomic, assign) CGPoint currentVelocity;

@end
