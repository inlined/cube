//
//  ModelView.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/13/12.
//  Copyright (c) 2012 EspressoBytes. All rights reserved.
//  A helper class teased apart from Apple boilerplate code to allow more
//  independent modeling.

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "SceneView.hh"

@interface ModelView : NSObject

@property (strong, nonatomic) SceneView* scene;
@property (assign, nonatomic) GLuint program;

// Creates a GL program. Must be called after setting the ESGL context
- (id) init;

// Creates any OpenGL buffers, shaders, etc.
- (void)setupGL;

// Should free reasonable amounts of memory to avoid being killed
// This may save model state.
- (void)tearDownGL;

// Shaders in the form "Shader.fsh" "Shader.vsh". The type is deduced from the
// extension.
- (BOOL)loadShaders:(NSArray*)shaders withAttribs:(NSArray*)attribs;
- (GLint)uniformWithName:(GLchar*)name;

- (void)update;
- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect;
@end
