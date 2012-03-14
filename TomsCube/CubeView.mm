//
//  CubeView.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/13/12.
//  Copyright (c) 2012 EspressoBytes. All rights reserved.
//

#import "CubeView.hh"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// format: XYZ position & normal of UL LL LR UR corners of each sticker in the
// face enum order definied by the cube model
GLfloat gCubeVertices[] = {
 // FRONT TOP
 0, 3, 3, 0, 0, 1,   0, 2, 3, 0, 0, 1,   1, 2, 3, 0, 0, 1,   1, 3, 3, 0, 0, 1,
 1, 3, 3, 0, 0, 1,   1, 2, 3, 0, 0, 1,   2, 2, 3, 0, 0, 1,   2, 3, 3, 0, 0, 1,
 2, 3, 3, 0, 0, 1,   2, 2, 3, 0, 0, 1,   3, 2, 3, 0, 0, 1,   3, 3, 3, 0, 0, 1,
  
 // FRONT EQUATOR
 0, 2, 3, 0, 0, 1,   0, 1, 3, 0, 0, 1,   1, 1, 3, 0, 0, 1,   1, 2, 3, 0, 0, 1,
 1, 2, 3, 0, 0, 1,   1, 1, 3, 0, 0, 1,   2, 1, 3, 0, 0, 1,   2, 2, 3, 0, 0, 1,
 2, 2, 3, 0, 0, 1,   2, 1, 3, 0, 0, 1,   3, 1, 3, 0, 0, 1,   3, 2, 3, 0, 0, 1,
  
 // FRONT BOTTOM
 0, 1, 3, 0, 0, 1,   0, 0, 3, 0, 0, 1,   1, 0, 0, 0, 0, 1,   1, 1, 0, 0, 0, 1,
 1, 1, 3, 0, 0, 1,   1, 0, 3, 0, 0, 1,   2, 0, 0, 0, 0, 1,   2, 1, 0, 0, 0, 1,
 2, 1, 3, 0, 0, 1,   2, 0, 3, 0, 0, 1,   3, 0, 0, 0, 0, 1,   3, 1, 0, 0, 0, 1,
  
 // RIGHT TOP
 3, 3, 3, 1, 0, 0,   3, 2, 3, 1, 0, 0,   3, 2, 2, 1, 0, 0,   3, 3, 2, 1, 0, 0,
 3, 3, 2, 1, 0, 0,   3, 2, 2, 1, 0, 0,   3, 2, 1, 1, 0, 0,   3, 3, 1, 1, 0, 0,
 3, 3, 1, 1, 0, 0,   3, 2, 1, 1, 0, 0,   3, 2, 0, 1, 0, 0,   3, 3, 0, 1, 0, 0,
  
 // RIGHT EQUATOR
 3, 2, 3, 1, 0, 0,   3, 1, 3, 1, 0, 0,   3, 1, 2, 1, 0, 0,   3, 2, 2, 1, 0, 0,
 3, 2, 2, 1, 0, 0,   3, 1, 2, 1, 0, 0,   3, 1, 1, 1, 0, 0,   3, 2, 1, 1, 0, 0,
 3, 2, 1, 1, 0, 0,   3, 1, 1, 1, 0, 0,   3, 1, 0, 1, 0, 0,   3, 2, 0, 1, 0, 0,

 // RIGHT BOTTOM
 3, 1, 3, 1, 0, 0,   3, 0, 3, 1, 0, 0,   3, 0, 2, 1, 0, 0,   3, 1, 2, 1, 0, 0,
 3, 1, 2, 1, 0, 0,   3, 0, 2, 1, 0, 0,   3, 0, 1, 1, 0, 0,   3, 1, 1, 1, 0, 0,
 3, 1, 1, 1, 0, 0,   3, 0, 1, 1, 0, 0,   3, 0, 0, 1, 0, 0,   3, 1, 0, 1, 0, 0,

 // BACK TOP
 3, 3, 0, 0, 0, -1,  3, 2, 0, 0, 0, -1,  2, 2, 0, 0, 0, -1,  2, 3, 0, 0, 0, -1,
 2, 3, 0, 0, 0, -1,  2, 2, 0, 0, 0, -1,  1, 2, 0, 0, 0, -1,  1, 3, 0, 0, 0, -1,
 1, 3, 0, 0, 0, -1,  1, 2, 0, 0, 0, -1,  0, 2, 0, 0, 0, -1,  0, 3, 0, 0, 0, -1,  
  
 // BACK EQUATOR
 3, 2, 0, 0, 0, -1,  3, 1, 0, 0, 0, -1,  2, 1, 0, 0, 0, -1,  2, 2, 0, 0, 0, -1,
 2, 2, 0, 0, 0, -1,  2, 1, 0, 0, 0, -1,  1, 1, 0, 0, 0, -1,  1, 2, 0, 0, 0, -1,
 1, 2, 0, 0, 0, -1,  1, 1, 0, 0, 0, -1,  0, 1, 0, 0, 0, -1,  0, 2, 0, 0, 0, -1,  

 // BACK BOTTOM
 3, 1, 0, 0, 0, -1,  3, 0, 0, 0, 0, -1,  2, 0, 0, 0, 0, -1,  2, 1, 0, 0, 0, -1,
 2, 1, 0, 0, 0, -1,  2, 0, 0, 0, 0, -1,  1, 0, 0, 0, 0, -1,  1, 1, 0, 0, 0, -1,
 1, 1, 0, 0, 0, -1,  1, 0, 0, 0, 0, -1,  0, 0, 0, 0, 0, -1,  0, 1, 0, 0, 0, -1,  

 // LEFT TOP
 3, 3, 0, -1, 0, 0,  3, 2, 0, -1, 0, 0,  3, 2, 1, -1, 0, 0,  3, 3, 1, -1, 0, 0,
 3, 3, 1, -1, 0, 0,  3, 2, 1, -1, 0, 0,  3, 2, 2, -1, 0, 0,  3, 3, 2, -1, 0, 0,
 3, 3, 2, -1, 0, 0,  3, 2, 2, -1, 0, 0,  3, 2, 3, -1, 0, 0,  3, 3, 3, -1, 0, 0,

 // LEFT EQUATOR
 3, 2, 0, -1, 0, 0,  3, 1, 0, -1, 0, 0,  3, 1, 1, -1, 0, 0,  3, 2, 1, -1, 0, 0,
 3, 2, 1, -1, 0, 0,  3, 1, 1, -1, 0, 0,  3, 1, 2, -1, 0, 0,  3, 2, 2, -1, 0, 0,
 3, 2, 2, -1, 0, 0,  3, 1, 2, -1, 0, 0,  3, 1, 3, -1, 0, 0,  3, 2, 3, -1, 0, 0,

 // LEFT BOTTOM
 3, 1, 0, -1, 0, 0,  3, 0, 0, -1, 0, 0,  3, 0, 1, -1, 0, 0,  3, 1, 1, -1, 0, 0,
 3, 1, 1, -1, 0, 0,  3, 0, 1, -1, 0, 0,  3, 0, 2, -1, 0, 0,  3, 1, 2, -1, 0, 0,
 3, 1, 2, -1, 0, 0,  3, 0, 2, -1, 0, 0,  3, 0, 3, -1, 0, 0,  3, 1, 3, -1, 0, 0,

 // TOP BACK
 0, 3, 0, 0, 1, 0,   0, 3, 1, 0, 1, 0,   1, 3, 1, 0, 1, 0,   1, 3, 0, 0, 1, 0,
 1, 3, 0, 0, 1, 0,   1, 3, 1, 0, 1, 0,   2, 3, 1, 0, 1, 0,   2, 3, 0, 0, 1, 0, 
 2, 3, 0, 0, 1, 0,   2, 3, 1, 0, 1, 0,   3, 3, 1, 0, 1, 0,   3, 3, 0, 0, 1, 0, 

 // TOP STANDING
 0, 3, 1, 0, 1, 0,   0, 3, 2, 0, 1, 0,   1, 3, 2, 0, 1, 0,   1, 3, 1, 0, 1, 0,
 1, 3, 1, 0, 1, 0,   1, 3, 2, 0, 1, 0,   2, 3, 2, 0, 1, 0,   2, 3, 1, 0, 1, 0, 
 2, 3, 1, 0, 1, 0,   2, 3, 2, 0, 1, 0,   3, 3, 2, 0, 1, 0,   3, 3, 1, 0, 1, 0, 

 // TOP FRONT
 0, 3, 2, 0, 1, 0,   0, 3, 3, 0, 1, 0,   1, 3, 3, 0, 1, 0,   1, 3, 2, 0, 1, 0,
 1, 3, 2, 0, 1, 0,   1, 3, 3, 0, 1, 0,   2, 3, 3, 0, 1, 0,   2, 3, 2, 0, 1, 0, 
 2, 3, 2, 0, 1, 0,   2, 3, 3, 0, 1, 0,   3, 3, 3, 0, 1, 0,   3, 3, 2, 0, 1, 0, 

 // BOTTOM FRONT
 0, 0, 3, 0, -1, 0,  0, 0, 2, 0, -1, 0,  1, 0, 2, 0, -1, 0,  1, 0, 3, 0, -1, 0,
 1, 0, 3, 0, -1, 0,  1, 0, 2, 0, -1, 0,  2, 0, 2, 0, -1, 0,  2, 0, 3, 0, -1, 0,
 2, 0, 3, 0, -1, 0,  2, 0, 2, 0, -1, 0,  3, 0, 2, 0, -1, 0,  3, 0, 3, 0, -1, 0,
  
 // BOTTOM STANDING
 0, 0, 2, 0, -1, 0,  0, 0, 1, 0, -1, 0,  1, 0, 1, 0, -1, 0,  1, 0, 2, 0, -1, 0,
 1, 0, 2, 0, -1, 0,  1, 0, 1, 0, -1, 0,  2, 0, 1, 0, -1, 0,  2, 0, 2, 0, -1, 0,
 2, 0, 2, 0, -1, 0,  2, 0, 1, 0, -1, 0,  3, 0, 1, 0, -1, 0,  3, 0, 2, 0, -1, 0,

 // BOTTOM BACK
 0, 0, 1, 0, -1, 0,  0, 0, 0, 0, -1, 0,  1, 0, 0, 0, -1, 0,  1, 0, 1, 0, -1, 0,
 1, 0, 1, 0, -1, 0,  1, 0, 0, 0, -1, 0,  2, 0, 0, 0, -1, 0,  2, 0, 1, 0, -1, 0,
 2, 0, 1, 0, -1, 0,  2, 0, 0, 0, -1, 0,  3, 0, 0, 0, -1, 0,  3, 0, 1, 0, -1, 0,
};

GLfloat color_pallet[] = {
  1.0, 0.0, 0.0,  // R
  1.0, 1.0, 1.0,  // W
  1.0, 0.69, 0.0, // O
  1.0, 1.0, 0.0,  // Y
  0.0, 1.0, 0.0,  // G
  0.0, 0.0, 1.0,  // B
};

GLfloat colors[648];

// Attribute index.
enum
{
  ATTRIB_VERTEX,
  ATTRIB_NORMAL,
  ATTRIB_COLOR_INDEX,
  NUM_ATTRIBUTES
};

@implementation CubeView

- (id)init
{
  self = [super init];
  if (self) {
    _cube = new Cube();
  }
  return self;
}

- (void)dealloc
{
  delete _cube;
}

- (void)setupGL
{
  [super setupGL];
  
  bool did_load = [self
      loadShaders:[NSArray arrayWithObjects:@"Phong.vsh", @"Phong.fsh", nil]
      withAttribs:[NSArray arrayWithObjects:@"position", @"normal", @"color", nil]];
  NSAssert(did_load, @"Failed to load shaders");
  
  // Create a container for memory mapped buffers
  glGenVertexArraysOES(1, &_vertexArray);
  glBindVertexArrayOES(_vertexArray);
  glGenBuffers(2, _vertexBuffers);
  
  // Create a mapping between gCubeVertexData and the first spot in the VAO
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[0]);
  glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertices), gCubeVertices, GL_STATIC_DRAW);
  
  // Describe gCubeVertexData as vertex positions every 24B starting at offset 0
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
  
  // Describe gCubeData as vertex normals every 24B starting at offset 12
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
  
  // In the other buffer, bind the byte indicies for colors
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[1]);
  [self updateColorBuffer];
  
  // 16 is just a non-reserved value
  glEnableVertexAttribArray(GLKVertexAttribColor);
  glVertexAttribPointer(GLKVertexAttribColor,
                        4, GL_FLOAT, GL_FALSE, 0, 0);
  
  // Unset the active VAO so other code cannot mess this up
  glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
  glDeleteBuffers(2, _vertexBuffers);
  glDeleteVertexArraysOES(1, &_vertexArray);
}


- (void)update
{
  [super update];
  
  // TODO: Is the camera no longer here? This probably needs to be rethought
  // and refactored for proper object composition
  GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
  baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
  
  GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(_rotation, 1.0f, 1.0f, 1.0f);
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  // TOM CONFUSION: what exactly is this? The shader has a fixed clight position.
  // This seems to be related to the camera so that model view normals are 
  // transformed to global normals
  _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
  
  _modelViewProjectionMatrix = GLKMatrix4Multiply(
      self.scene.effect.transform.projectionMatrix,
      modelViewMatrix);
  
  _rotation += self.scene.timeSinceLastUpdate * 0.5f;
  
  if (_colors_dirty) {
      [self updateColorBuffer];
  }
}

- (void)updateColorBuffer
{
  _colors_dirty = NO;
  // Bit blast the color buffer
  for (WhichFace face_id = FRONT_FACE; face_id < NUM_FACES; ++face_id) {
    Cube::Face face = _cube->GetFace(face_id);
    for (int square = 0; square < 9; ++square) {
      GLfloat* color = &color_pallet[3 * face[square]];
      for (int vertex = 0; vertex < 4; ++vertex) {
        int index = (vertex + face_id * 6) * 3;
        colors[index] = color[0];
        colors[index + 1] = color[1];
        colors[index + 2] = color[2];
      }
    }
  }
  // Assume we are already using this model's VAO
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[1]);
  glBufferData(GL_ARRAY_BUFFER, sizeof(colors), colors, GL_DYNAMIC_DRAW);
}

- (void)glkView:(GLKView*)view drawInRect:(CGRect)rect
{
  [super glkView:view drawInRect:rect];
  glBindVertexArrayOES(_vertexArray);
  
  
  // Render the object again with ES2
  glUseProgram(self.program);
  
  
  // Assign our calculated uniforms to the pipeline
  glUniformMatrix4fv([self uniformWithName:"modelViewProjectionMatrix"],
                     1, 0, _modelViewProjectionMatrix.m);
  glUniformMatrix3fv([self uniformWithName:"normalMatrix"],
                     1, 0, _normalMatrix.m);
  
  for (int face = 0; face < 6; ++face) {
    for (int square = 0; square < 9; ++square) {
      glDrawArrays(GL_LINE_LOOP, (face * 9 + square) * 4, 4);
    }
  }
}


@end
