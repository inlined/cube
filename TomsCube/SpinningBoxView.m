//
//  SpinningBoxView.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/14/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

#import "SpinningBoxView.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
  UNIFORM_MODELVIEWPROJECTION_MATRIX,
  UNIFORM_NORMAL_MATRIX,
  NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
  ATTRIB_VERTEX,
  ATTRIB_NORMAL,
  NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[216] = 
{
  // Data layout for each line below is:
  // positionX, positionY, positionZ,     normalX, normalY, normalZ,
  0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
  
  0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
  
  -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
  
  -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
  
  0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
  
  0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

@implementation SpinningBoxView

- (void)setupGL
{
  [super setupGL];
  
  bool did_load = [self
      loadShaders:[NSArray arrayWithObjects:@"Boxes.vsh", @"Boxes.fsh", nil]
      withAttribs:[NSArray arrayWithObjects:@"position", @"normal", nil]];
  NSAssert(did_load, @"Failed to load shaders");
            
  // Get uniform locations.
  uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] =
      [self uniformWithName:"modelViewProjectionMatrix"];
  uniforms[UNIFORM_NORMAL_MATRIX] = 
      [self uniformWithName:"normalMatrix"];
  
  // Create a container for memory mapped buffers
  glGenVertexArraysOES(1, &_vertexArray);
  glBindVertexArrayOES(_vertexArray);
  
  // Create a mapping between gCubeVertexData and the first spot in the VAO
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
  
  // Describe gCubeVertexData as vertex positions every 24B starting at offset 0
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
  
  // Describe gCubeData as vertex normals every 24B starting at offset 12
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
  
  // Unset the active VAO so other code cannot mess this up
  glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
  glDeleteBuffers(1, &_vertexBuffer);
  glDeleteVertexArraysOES(1, &_vertexArray);
}


- (void)update
{
  [super update];
  
  GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
  baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
  
  // Compute the model view matrix for the object rendered with GLKit
  GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  self.scene.effect.transform.modelviewMatrix = modelViewMatrix;
  
  // Compute the model view matrix for the object rendered with ES2
  modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
  modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
  
  _modelViewProjectionMatrix = GLKMatrix4Multiply(
      self.scene.effect.transform.projectionMatrix, modelViewMatrix);
  
  _rotation += self.scene.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect
{
  [super glkView:view drawInRect:rect];
  glBindVertexArrayOES(_vertexArray);
  
  // Render the object with GLKit
  [self.scene.effect prepareToDraw];
  
  glDrawArrays(GL_TRIANGLES, 0, 36);
  
  // Render the object again with ES2
  glUseProgram(self.program);
  
  glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
  glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
  
  glDrawArrays(GL_TRIANGLES, 0, 36);
}

@end
