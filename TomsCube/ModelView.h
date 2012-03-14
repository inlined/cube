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

@interface ModelView : NSObject
- (id) initWithProgram:(GLuint) program;
- (void) setupGL;
- (void) tearDownGL;
@property (assign, nonatomic) GLuint program;
@end

@interface ModelViewWithShaders : ModelView
- (id) initWithProgram:(GLuint) program;
// Shaders in the form "Shader.fsh" "Shader.vsh". The type is deduced from the
// extension.
- (BOOL)loadShaders:(NSArray*)shaders withAttribs:(NSArray*)attribs;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
- (GLint) uniformWithName:(GLchar*)name;
@end
