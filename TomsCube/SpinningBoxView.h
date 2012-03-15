//
//  SpinningBoxView.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/14/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "ModelView.hh"

@interface SpinningBoxView : ModelView {
GLKMatrix4 _modelViewProjectionMatrix;
GLKMatrix3 _normalMatrix;
float _rotation;

GLuint _vertexArray;
GLuint _vertexBuffer;
}
@end
