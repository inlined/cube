//
//  ModelView.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/13/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import "ModelView.h"

@implementation ModelView

@synthesize program = _program;

- (id) initWithProgram:(GLuint) program
{
  self = [super init];
  if (self) {
    _program = program;
  }
  return self;
}
- (void) setupGL {}
- (void) tearDownGL
{
  self.program = 0;
}

@end

@implementation ModelViewWithShaders

- (id) initWithProgram:(GLuint) program
{
  return self = [super initWithProgram:program];
}

- (void) setupGL
{
  [super setupGL];

}

- (void) tearDownGL
{
  [super tearDownGL];
}

- (BOOL)loadShaders:(NSArray*) shaders withAttribs:(NSArray*) attribs
{
  GLuint shader_handles[[shaders count]];
  
  for (int i = 0; i < [shaders count]; ++i) {
    // TOM note: why was [description] necessary?
    NSString* shader = [[shaders objectAtIndex:i] description];
    NSString* extension = [shader pathExtension];
    NSString* resource =
        [shader substringToIndex:[shader length] - [extension length] - 1];
    NSString* path =
        [[NSBundle mainBundle] pathForResource:resource ofType:extension];
    GLenum type;
    if ([extension isEqualToString:@"vsh"]) {
      type = GL_VERTEX_SHADER;
    } else if ([extension isEqualToString:@"fsh"]) {
      type = GL_FRAGMENT_SHADER;
    } else {
      NSLog(@"Skipping unsupported shader extension %@", extension);
      continue;
    }
    
    if (![self compileShader:&shader_handles[i] type:type file:path]) {
      NSLog(@"Failed to compile shader %@", shader);
      return NO;
    }
    
    glAttachShader(self.program, shader_handles[i]);
  }
  
  for (int i = 0; i < [attribs count]; ++i) {
    glBindAttribLocation(self.program, i, [[attribs objectAtIndex:i] cString]);
  }
  
  // Link program.
  if (![self linkProgram:self.program]) {
    NSLog(@"Failed to link program: %d", self.program);
    
    for (int i = 0; i < [shaders count]; ++i) {
      if (shader_handles[i]) {
        glDeleteShader(shader_handles[i]);
      }
    }
    self.program = 0;
    
    return NO;
  }
  
  // Release shaders now that they are already linked into the program
  // Release vertex and fragment shaders.
  for (int i = 0; i < [shaders count]; ++i) {
    if (shader_handles[i]) {
      glDetachShader(self.program, shader_handles[i]);
      glDeleteShader(shader_handles[i]);
    }
  }
  
  return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
  GLint status;
  const GLchar *source;
  
  source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
  if (!source) {
    NSLog(@"Failed to load vertex shader");
    return NO;
  }
  
  *shader = glCreateShader(type);
  glShaderSource(*shader, 1, &source, NULL);
  glCompileShader(*shader);
  
#if defined(DEBUG)
  GLint logLength;
  glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetShaderInfoLog(*shader, logLength, &logLength, log);
    NSLog(@"Shader compile log:\n%s", log);
    free(log);
  }
#endif
  
  glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
  if (status == 0) {
    glDeleteShader(*shader);
    return NO;
  }
  
  return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
  GLint status;
  glLinkProgram(prog);
  
#if defined(DEBUG)
  GLint logLength;
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program link log:\n%s", log);
    free(log);
  }
#endif
  
  glGetProgramiv(prog, GL_LINK_STATUS, &status);
  if (status == 0) {
    return NO;
  }
  
  return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
  GLint logLength, status;
  
  glValidateProgram(prog);
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program validate log:\n%s", log);
    free(log);
  }
  
  glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
  if (status == 0) {
    return NO;
  }
  
  return YES;
}

- (GLint) uniformWithName:(GLchar*) name
{
  return glGetUniformLocation(self.program, name);
}

@end
