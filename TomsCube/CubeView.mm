//
//  CubeView.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/13/12.
//  Copyright (c) 2012 EspressoBytes. All rights reserved.
//

#import "CubeView.hh"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#define FACING_CUBE_STICKER(minx, maxx, miny, maxy, z, normz) \
  minx, maxy, z, 0, 0, normz, \
  minx, miny, z, 0, 0, normz, \
  maxx, maxy, z, 0, 0, normz, \
  \
  maxx, maxy, z, 0, 0, normz, \
  minx, miny, z, 0, 0, normz, \
  maxx, miny, z, 0, 0, normz

#define LATERAL_CUBE_STICKER(x, miny, maxy, minz, maxz, normx) \
  x, maxy, maxz, normx, 0, 0, \
  x, miny, maxz, normx, 0, 0, \
  x, maxy, minz, normx, 0, 0, \
  \
  x, maxy, minz, normx, 0, 0, \
  x, miny, maxz, normx, 0, 0, \
  x, miny, minz, normx, 0, 0

#define VERTICAL_CUBE_STICKER(minx, maxx, y, minz, maxz, normy) \
  minx, y, minz, 0, normy, 0, \
  minx, y, maxz, 0, normy, 0, \
  maxx, y, minz, 0, normy, 0, \
  \
  maxx, y, minz, 0, normy, 0, \
  minx, y, maxz, 0, normy, 0, \
  maxx, y, maxz, 0, normy, 0

// format: XYZ position & normal of UL LL UR, UR, LL, LR triangles of each
// sticker in the face enum order definied by the cube model
GLfloat gCubeVertices[] = {
  // FRONT TOP
  FACING_CUBE_STICKER(0, 0.95, 2.05, 2.95, 3, 1),
  FACING_CUBE_STICKER(1.05, 1.95, 2.05, 2.95, 3, 1),
  FACING_CUBE_STICKER(2.05, 2.95, 2.05, 2.95, 3, 1),
  
  // FRONT EQUATOR
  FACING_CUBE_STICKER(0, 0.95, 1.05, 1.95, 3, 1),
  FACING_CUBE_STICKER(1.05, 1.95, 1.05, 1.95, 3, 1),
  FACING_CUBE_STICKER(2.05, 2.95, 1.05, 1.95, 3, 1),
  
  // FRONT BOTTOM
  FACING_CUBE_STICKER(0, 0.95, 0.05, 0.95, 3, 1),
  FACING_CUBE_STICKER(1.05, 1.95, 0.05, 0.95, 3, 1),
  FACING_CUBE_STICKER(2.05, 2.95, 0.05, 0.95, 3, 1),

  // RIGHT TOP
  LATERAL_CUBE_STICKER(3, 2.05, 2.95, 2.05, 2.95, 1),
  LATERAL_CUBE_STICKER(3, 2.05, 2.95, 1.05, 1.95, 1),
  LATERAL_CUBE_STICKER(3, 2.05, 2.95, 0.05, 0.95, 1),
  
  // RIGHT EQUATOR
  LATERAL_CUBE_STICKER(3, 1.05, 1.95, 2.05, 2.95, 1),
  LATERAL_CUBE_STICKER(3, 1.05, 1.95, 1.05, 1.95, 1),
  LATERAL_CUBE_STICKER(3, 1.05, 1.95, 0.05, 0.95, 1),
  
  // RIGHT BOTTOM
  LATERAL_CUBE_STICKER(3, 0.05, 0.95, 2.05, 2.95, 1),
  LATERAL_CUBE_STICKER(3, 0.05, 0.95, 1.05, 1.95, 1),
  LATERAL_CUBE_STICKER(3, 0.05, 0.95, 0.05, 0.95, 1),
  
  // BACK TOP
  FACING_CUBE_STICKER(2.05, 2.95, 2.05, 2.95, 0, -1), 
  FACING_CUBE_STICKER(1.05, 1.95, 2.05, 2.95, 0, -1),
  FACING_CUBE_STICKER(0.05, 0.95, 2.05, 2.95, 0, -1),
  
  // BACK EQUATOR
  FACING_CUBE_STICKER(2.05, 2.95, 1.05, 1.95, 0, -1), 
  FACING_CUBE_STICKER(1.05, 1.95, 1.05, 1.95, 0, -1),
  FACING_CUBE_STICKER(0.05, 0.95, 1.05, 1.95, 0, -1),
   
  // BACK BOTTOM
  FACING_CUBE_STICKER(2.05, 2.95, 0.05, 0.95, 0, -1), 
  FACING_CUBE_STICKER(1.05, 1.95, 0.05, 0.95, 0, -1),
  FACING_CUBE_STICKER(0.05, 0.95, 0.05, 0.95, 0, -1),
  
  // LEFT TOP
  LATERAL_CUBE_STICKER(0, 2.05, 2.95, 2.05, 2.95, -1),
  LATERAL_CUBE_STICKER(0, 2.05, 2.95, 1.05, 1.95, -1),
  LATERAL_CUBE_STICKER(0, 2.05, 2.95, 0.05, 0.95, -1), 
  
  // LEFT EQUATOR
  LATERAL_CUBE_STICKER(0, 1.05, 1.95, 2.05, 2.95, -1),
  LATERAL_CUBE_STICKER(0, 1.05, 1.95, 1.05, 1.95, -1),
  LATERAL_CUBE_STICKER(0, 1.05, 1.95, 0.05, 0.95, -1), 
   
  // LEFT BOTTOM
  LATERAL_CUBE_STICKER(0, 0.05, 0.95, 2.05, 2.95, -1),
  LATERAL_CUBE_STICKER(0, 0.05, 0.95, 1.05, 1.95, -1),
  LATERAL_CUBE_STICKER(0, 0.05, 0.95, 0.05, 0.95, -1), 
 
  // TOP BACK
  VERTICAL_CUBE_STICKER(0.05, 0.95, 3, 0.05, 0.95, 1),
  VERTICAL_CUBE_STICKER(1.05, 1.95, 3, 0.05, 0.95, 1),
  VERTICAL_CUBE_STICKER(2.05, 2.95, 3, 0.05, 0.95, 1),
  
  // TOP STANDING
  VERTICAL_CUBE_STICKER(0.05, 0.95, 3, 1.05, 1.95, 1),
  VERTICAL_CUBE_STICKER(1.05, 1.95, 3, 1.05, 1.95, 1),
  VERTICAL_CUBE_STICKER(2.05, 2.95, 3, 1.05, 1.95, 1),
   
  // TOP FRONT
  VERTICAL_CUBE_STICKER(0.05, 0.95, 3, 2.05, 2.95, 1),
  VERTICAL_CUBE_STICKER(1.05, 1.95, 3, 2.05, 2.95, 1),
  VERTICAL_CUBE_STICKER(2.05, 2.95, 3, 2.05, 2.95, 1), 
  
  // BOTTOM FRONT
  VERTICAL_CUBE_STICKER(0.05, 0.95, 0, 2.05, 2.95, -1),
  VERTICAL_CUBE_STICKER(1.05, 1.95, 0, 2.05, 2.95, -1),
  VERTICAL_CUBE_STICKER(2.05, 2.95, 0, 2.05, 2.95, -1),
  
  // BOTTOM STANDING
  VERTICAL_CUBE_STICKER(0.05, 0.95, 0, 1.05, 1.95, -1),
  VERTICAL_CUBE_STICKER(1.05, 1.95, 0, 1.05, 1.95, -1),
  VERTICAL_CUBE_STICKER(2.05, 2.95, 0, 1.05, 1.95, -1),
  
  // BOTTOM BACK
  VERTICAL_CUBE_STICKER(0.05, 0.95, 0, 0.05, 0.95, -1),
  VERTICAL_CUBE_STICKER(1.05, 1.95, 0, 0.05, 0.95, -1),
  VERTICAL_CUBE_STICKER(2.05, 2.95, 0, 0.05, 0.95, -1),
};

GLfloat color_pallet[] = {
  0.8, 0.0, 0.0,  // R
  1.0, 1.0, 1.0,  // W
  1.0, 0.69, 0.0, // O
  1.0, 1.0, 0.0,  // Y
  0.0, 0.37, 0.0, // G
  0.0, 0.0, 1.0,  // B
};

// Color elements per vertex per square per face per cube
GLfloat colors[3 * 3 * 2 * 9 * 6];

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
  
  // Create a mapping between gCubeVertecies and the first spot in the VAO
  // This buffer holds a static map of interleaved positions and normals.
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[0]);
  glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertices), gCubeVertices, GL_STATIC_DRAW);
  
  // Every cycle of 24B starting at offset 0 is a 3 float vector of positions
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
  
  // Every cycle of 24B starting at offset 12 is a 3 flaot vector of normals
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
  
  // In the other buffer, bind a dynamic vector of colors per vertex
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[1]);
  [self updateColorBuffer];
  
  // 16 is just a non-reserved value
  glEnableVertexAttribArray(GLKVertexAttribColor);
  glVertexAttribPointer(GLKVertexAttribColor,
                        3, GL_FLOAT, GL_FALSE, 0, 0);
  
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
  
  GLKMatrix4 rot_cube =
      GLKMatrix4MakeRotation(_rotation, 1.0f, 1.0f, 1.0f);
  GLKMatrix4 position_cube = GLKMatrix4MakeTranslation(-1.5, -1.5, -1.5);
  GLKMatrix4 shrink_cube = GLKMatrix4MakeScale(0.5, 0.5, 0.5);
  
  GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(shrink_cube, position_cube);
  //modelViewMatrix = GLKMatrix4Multiply(rot_cube, modelViewMatrix);
  
  modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
  
  // TOM CONFUSION: what exactly is this? The shader has a fixed clieht position.
  // This seems to be related to the camera so that model view normals are 
  // transformed to global normals
  _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
  
  _modelViewProjectionMatrix = GLKMatrix4Multiply(
      self.scene.effect.transform.projectionMatrix,
      modelViewMatrix);
  
  _rotation += self.scene.timeSinceLastUpdate * 0.5f;
  
  _ambientLight = GLKVector3Make(0.1, 0.1, 0.1);
  if (_colors_dirty) {
      [self updateColorBuffer];
  }
}

- (void)updateColorBuffer
{
  _colors_dirty = NO;
  // Bit blast the color buffer
  for (int sticker = 0; sticker < 9 * 6; ++sticker) {
    Color color_code = _cube->raw_buffer()[sticker];
    GLfloat* color3v = &color_pallet[3 * color_code];
    for (int vertex = 0; vertex < 6; ++vertex) {
      GLfloat* buffer = &colors[(sticker * 6 + vertex) * 3];
      buffer[0] = color3v[0];
      buffer[1] = color3v[1];
      buffer[2] = color3v[2];
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
  
  
  glUseProgram(self.program);
  
  // Assign our calculated uniforms to the pipeline
  glUniformMatrix4fv(
      [self uniformWithName:(GLchar*)"modelViewProjectionMatrix"],
      1, 0, _modelViewProjectionMatrix.m);
  glUniformMatrix3fv(
      [self uniformWithName:(GLchar*)"normalMatrix"],
      1, 0, _normalMatrix.m);
  glUniform3fv(
       [self uniformWithName:(GLchar*)"ambientLight"], 1, _ambientLight.v);
  
  [self draw];
}

- (void) draw
{
  // my kingdom for GL_QUADS...
  glDrawArrays(GL_TRIANGLES, 0, 
               sizeof(gCubeVertices) / (6 * sizeof(gCubeVertices[0])));

}



@end
