//
//  CubeView.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/13/12.
//  Copyright (c) 2012 EspressoBytes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "CubeModel.h"
#import "ModelView.hh"
#import "AnimationQueue.h"

@interface CubeView : ModelView {
  // Model
  Cube* _cube;
  
  // Shader attribs
  GLuint _vertexArray;
  GLuint _vertexBuffers[2];
  
  // Shader uniforms. Two sets are stored to stay true to iOS's render-on-demand 
  // model
  GLKMatrix4 _staticModelViewProjectionMatrix;
  GLKMatrix3 _staticNormalMatrix;
  GLKMatrix4 _animationModelViewProjectionMatrix;
  GLKMatrix3 _animationNormalMatrix;

  AnimationQueue* _animationQueue;
  AnimationSnapshot _animationSnapshot;
  bool _isAnimating;
  
  // Lazy eval guides
  bool _staticMatricesDirty;
  bool _colorsDirty;
}

- (void)viewDidLoad;
- (void)viewDidUnload;
- (void)handleRotation:(UIGestureRecognizer*)gestureRecognizer;
- (void)handleSwipe:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleTap:(UIGestureRecognizer*)recognizer;

-(void) updateColorBuffer;
-(void) twistModel:(Cubelet)cubelet direction:(Twist)direction;
@end
