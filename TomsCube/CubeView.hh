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

@interface CubeView : NSObject {
  Cube* _cube;
  GLuint _vertexArray;
  GLuint _vertexBuffer;
}
@property (strong, nonatomic) EAGLContext* context;

- (id) initWithContext:(EAGLContext*) context;
- (void) draw;
@end
