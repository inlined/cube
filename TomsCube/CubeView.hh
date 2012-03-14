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

@interface CubeView : ModelView {
  // Model
  Cube* _cube;
  
  // Shader attribs
  GLuint _vertexArray;
  GLuint _vertexBuffers[2];
  
  // Shader uniforms
  GLKMatrix4 _modelViewProjectionMatrix;
  GLKMatrix3 _normalMatrix;
  
  // Animation parameters
  float _rotation;
  bool _colors_dirty;
}
-(void) updateColorBuffer;
@end
