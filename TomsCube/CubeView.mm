//
//  CubeView.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/13/12.
//  Copyright (c) 2012 EspressoBytes. All rights reserved.
//

#import "CubeView.hh"
#import "NSInvocation+Shorthand.h"

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
  FACING_CUBE_STICKER(0.05, 0.95, 2.05, 2.95, 3, 1),
  FACING_CUBE_STICKER(1.05, 1.95, 2.05, 2.95, 3, 1),
  FACING_CUBE_STICKER(2.05, 2.95, 2.05, 2.95, 3, 1),
  
  // FRONT EQUATOR
  FACING_CUBE_STICKER(0.05, 0.95, 1.05, 1.95, 3, 1),
  FACING_CUBE_STICKER(1.05, 1.95, 1.05, 1.95, 3, 1),
  FACING_CUBE_STICKER(2.05, 2.95, 1.05, 1.95, 3, 1),
  
  // FRONT BOTTOM
  FACING_CUBE_STICKER(0.05, 0.95, 0.05, 0.95, 3, 1),
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
  LATERAL_CUBE_STICKER(0, 2.05, 2.95, 0.05, 0.95, -1),
  LATERAL_CUBE_STICKER(0, 2.05, 2.95, 1.05, 1.95, -1),
  LATERAL_CUBE_STICKER(0, 2.05, 2.95, 2.05, 2.95, -1), 
  
  // LEFT EQUATOR
  LATERAL_CUBE_STICKER(0, 1.05, 1.95, 0.05, 0.95, -1),
  LATERAL_CUBE_STICKER(0, 1.05, 1.95, 1.05, 1.95, -1),
  LATERAL_CUBE_STICKER(0, 1.05, 1.95, 2.05, 2.95, -1), 
   
  // LEFT BOTTOM
  LATERAL_CUBE_STICKER(0, 0.05, 0.95, 0.05, 0.95, -1),
  LATERAL_CUBE_STICKER(0, 0.05, 0.95, 1.05, 1.95, -1),
  LATERAL_CUBE_STICKER(0, 0.05, 0.95, 2.05, 2.95, -1), 
 
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
  0.8, 0.0, 0.0,    // R
  1.0, 1.0, 1.0,    // W
  .75, 0.4, 0.02, // O - ambient is specifically subtracted to help 
                    // differentiate from yellow
  1.0, 1.0, 0.0,    // Y
  0.0, 0.37, 0.0,   // G
  0.0, 0.0, 1.0,    // B
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

// TODO: Is the camera no longer here? This probably needs to be rethought
// and refactored for proper object composition
GLKMatrix4 gCameraMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
GLKMatrix4 gPositionCubeMatrix = GLKMatrix4MakeTranslation(-1.5, -1.5, -1.5);
GLKMatrix4 gShrinkCubeMatrix = GLKMatrix4MakeScale(0.66, 0.66, 0.66);
GLKMatrix4 gNormalizeCubeMatrix =
    GLKMatrix4Multiply(gShrinkCubeMatrix, gPositionCubeMatrix);
GLKVector3 gAmbientLight = GLKVector3Make(0.1, 0.1, 0.1);

@implementation CubeView

- (id)init
{
  self = [super init];
  if (self) {
    _cube = new Cube();
    _animationQueue = [AnimationQueue new];
  }
  return self;
}

- (void)dealloc
{
  delete _cube;
}

- (void)viewDidLoad
{}
- (void)viewDidUnload
{
  //TODO implement
}

- (void)handleRotation:(UIGestureRecognizer*)gestureRecognizer
{
  static float rad_change = 0;
  UIRotationGestureRecognizer* rotation =
      (UIRotationGestureRecognizer*)gestureRecognizer;
  rad_change += rotation.rotation;
  if ([rotation state] == UIGestureRecognizerStateEnded) {
    if (rad_change > M_PI_4) {
      [self startTwist:FRONT direction:NORMAL];
    } else if (rad_change < -M_PI_4) {
      [self startTwist:FRONT direction:PRIME];
    }
    rad_change = 0;
  }
}

- (void)handleTap:(UIGestureRecognizer*)gestureRecognizer
{
  NSLog(@"Did tap");
}

- (void)handleSwipe:(UIGestureRecognizer *)gestureRecognizer;
{
  UISwipeGestureRecognizer* swipe =
      (UISwipeGestureRecognizer*)gestureRecognizer;
  UISwipeGestureRecognizerDirection swipe_direction = [swipe direction];
  UIView* view = self.scene.view;
  CGPoint centroid = [swipe locationInView:view];
  CGRect frame = view.frame;
  int clipX = frame.size.width / 8;
  int clipY = frame.size.height / 4;
  CGRect clipped = CGRectInset(frame, clipX, clipY);

  NSLog(@"Point:%@ Frame:%@", 
        NSStringFromCGPoint(centroid),
        NSStringFromCGRect(clipped));
  if (CGRectContainsPoint(clipped, centroid)) {
    NSLog(@"In square");
    float col_ratio = (centroid.x - frame.origin.x) / frame.size.width * 3.0;
    float row_ratio = (centroid.y - frame.origin.y) / frame.size.height * 3.0;
    Cubelet col = MIDDLE;
    Cubelet row = EQUATOR;
    if (col_ratio < 1.1) {
      col = LEFT;
    } else if (col_ratio > 1.9) {
      col = RIGHT;
    }
    if (row_ratio < 1.2) {
      row = UP;
    } else if (row_ratio > 1.8) {
      row = DOWN;
    }
    NSLog(@"Ratio is col:%f row:%f", col_ratio, row_ratio);
    switch (swipe_direction) {
      case UISwipeGestureRecognizerDirectionUp:
        [self startTwist:col direction:PRIME];
        break;
      case UISwipeGestureRecognizerDirectionDown:
        [self startTwist:col direction:NORMAL];
        break;
      case UISwipeGestureRecognizerDirectionLeft:
        [self startTwist:row direction:NORMAL];
        break;
      case UISwipeGestureRecognizerDirectionRight:
        [self startTwist:row direction:PRIME];
        break;
    };
  } else {
    [self startRotation:
       swipe_direction == UISwipeGestureRecognizerDirectionRight ? ROT_RIGHT :
       swipe_direction == UISwipeGestureRecognizerDirectionLeft ? ROT_LEFT :
       swipe_direction == UISwipeGestureRecognizerDirectionUp ? ROT_UP :
       ROT_DOWN];
  }
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
  [self updateColorBuffer];
  
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[1]);
  
  glEnableVertexAttribArray(GLKVertexAttribColor);
  glVertexAttribPointer(GLKVertexAttribColor,
                        3, GL_FLOAT, GL_FALSE, 0, 0);
  
  glUseProgram(self.program);
  glUniform3fv(
      [self uniformWithName:(GLchar*)"ambientLight"], 1, gAmbientLight.v);
  glUseProgram(0);

  // Unset the active VAO so other code cannot mess this up
  glBindVertexArrayOES(0);
  
  
  // Load the uniforms the first time so we can lazily avoid loading them in the future
  _staticMatricesDirty = YES;
  _colorsDirty = YES;
  _isAnimating = NO;
}

- (void)tearDownGL
{
  glDeleteBuffers(2, _vertexBuffers);
  glDeleteVertexArraysOES(1, &_vertexArray);
}


- (void)update
{
  [super update];
  
  // TODO: Send signals from the app controler that the view has changed.
  if (_staticMatricesDirty) {
    [self updateStaticMatricesForProjection:
         self.scene.effect.transform.projectionMatrix];
  }
  
  _isAnimating = [_animationQueue fastFoward:self.scene.timeSinceLastUpdate
                                 forSnapshot:&_animationSnapshot];
  if (_isAnimating) {
    GLKMatrix4 animationMatrix =
        GLKMatrix4MakeWithQuaternion(_animationSnapshot.state);
    animationMatrix = GLKMatrix4Multiply(animationMatrix, gNormalizeCubeMatrix);
    animationMatrix = GLKMatrix4Multiply(gCameraMatrix, animationMatrix);
    _animationNormalMatrix = GLKMatrix3InvertAndTranspose(
        GLKMatrix4GetMatrix3(animationMatrix),
        NULL);
    _animationModelViewProjectionMatrix = GLKMatrix4Multiply(
        self.scene.effect.transform.projectionMatrix,
        animationMatrix);
  }
      
  // This must come after retrieving animation parameters, becuase the animation
  // queue may trigger a callback which mutates the model.
  if (_colorsDirty) {
      [self updateColorBuffer];
  }
}

- (void)updateStaticMatricesForProjection:(GLKMatrix4)projectionMatrix
{
  GLKMatrix4 modelViewMatrix =
      GLKMatrix4Multiply(gCameraMatrix, gNormalizeCubeMatrix);
  _staticNormalMatrix = GLKMatrix3InvertAndTranspose(
      GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
  _staticModelViewProjectionMatrix =
      GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
  _staticMatricesDirty = NO;
}

- (void)updateColorBuffer
{
  _colorsDirty = NO;
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
  
  [self draw];
}

- (void)loadUniformsWithAnimation:(bool)animation
{
  if (animation) {
    glUniformMatrix4fv(
        [self uniformWithName:(GLchar*)"modelViewProjectionMatrix"],
        1, 0, _animationModelViewProjectionMatrix.m);
    glUniformMatrix3fv(
        [self uniformWithName:(GLchar*)"normalMatrix"],
        1, 0, _animationNormalMatrix.m);
  } else {    
    glUniformMatrix4fv(
         [self uniformWithName:(GLchar*)"modelViewProjectionMatrix"],
         1, 0, _staticModelViewProjectionMatrix.m);
    glUniformMatrix3fv(
         [self uniformWithName:(GLchar*)"normalMatrix"],
         1, 0, _staticNormalMatrix.m);
  }
}

#define DRAW_STICKER_RANGE(face, start, count) \
  glDrawArrays(GL_TRIANGLES, 6 * (face * 9 + start), 6 * count);
#define DRAW_STICKER_ROW(face, row) DRAW_STICKER_RANGE(face, (row) * 3, 3)
#define DRAW_STICKER_COL(face, col) \
  DRAW_STICKER_RANGE(face, col, 1); \
  DRAW_STICKER_RANGE(face, (col) + 3, 1); \
  DRAW_STICKER_RANGE(face, (col) + 6, 1)
#define DRAW_WHOLE_FACE(face) DRAW_STICKER_RANGE(face, 0, 9);
#define DRAW_WHOLE_CUBE() glDrawArrays(GL_TRIANGLES, 0, 6 * 9 * 6)

- (void)draw
{
  Cubelet affectedArea = _animationSnapshot.affectedArea;
  if (!_isAnimating) {
    [self loadUniformsWithAnimation:NO];
    DRAW_WHOLE_CUBE();
    return;
  } else if (affectedArea == WHOLE_CUBE) {
    [self loadUniformsWithAnimation:YES];
    DRAW_WHOLE_CUBE();
    return;
  }

  if (affectedArea >= LEFT && affectedArea <= RIGHT) {
    int col = affectedArea - LEFT;
    [self loadUniformsWithAnimation:YES];
    DRAW_STICKER_COL(FRONT_FACE, col);
    DRAW_STICKER_COL(TOP_FACE, col);
    DRAW_STICKER_COL(BACK_FACE, 2 - col);
    DRAW_STICKER_COL(BOTTOM_FACE, col);
    if (affectedArea == LEFT) {
      DRAW_WHOLE_FACE(LEFT_FACE);
    } else if (affectedArea == RIGHT) {
      DRAW_WHOLE_FACE(RIGHT_FACE);
    }
    
    [self loadUniformsWithAnimation:NO];
    DRAW_STICKER_COL(FRONT_FACE, (col + 1) %3 );
    DRAW_STICKER_COL(TOP_FACE, (col + 1) % 3);
    DRAW_STICKER_COL(BACK_FACE, (3 - col) % 3);
    DRAW_STICKER_COL(BOTTOM_FACE, (col + 1) % 3);
    DRAW_STICKER_COL(FRONT_FACE, (col + 2) % 3);
    DRAW_STICKER_COL(TOP_FACE, (col + 2) % 3);
    DRAW_STICKER_COL(BACK_FACE, (4 - col) % 3);
    DRAW_STICKER_COL(BOTTOM_FACE, (col + 2)%3);
    if (affectedArea != LEFT) {
      DRAW_WHOLE_FACE(LEFT_FACE);
    }
    if (affectedArea != RIGHT) {
      DRAW_WHOLE_FACE(RIGHT_FACE);
    }
  } else if (affectedArea >= UP && affectedArea <= DOWN) {
    int row = affectedArea - UP;
    [self loadUniformsWithAnimation:YES];
    DRAW_STICKER_ROW(FRONT_FACE, row);
    DRAW_STICKER_ROW(RIGHT_FACE, row);
    DRAW_STICKER_ROW(BACK_FACE, row);
    DRAW_STICKER_ROW(LEFT_FACE, row);
    if (affectedArea == UP) {
      DRAW_WHOLE_FACE(TOP_FACE);
    } else if (affectedArea == DOWN) {
      DRAW_WHOLE_FACE(BOTTOM_FACE);
    }
    
    [self loadUniformsWithAnimation:NO];
    DRAW_STICKER_ROW(FRONT_FACE, (row + 1) % 3);
    DRAW_STICKER_ROW(RIGHT_FACE, (row + 1) % 3);
    DRAW_STICKER_ROW(BACK_FACE, (row + 1) % 3);
    DRAW_STICKER_ROW(LEFT_FACE, (row + 1) % 3);
    DRAW_STICKER_ROW(FRONT_FACE, (row + 2) % 3);
    DRAW_STICKER_ROW(RIGHT_FACE, (row + 2) %3);
    DRAW_STICKER_ROW(BACK_FACE, (row + 2) % 3);
    DRAW_STICKER_ROW(LEFT_FACE, (row + 2) % 3);
    if (affectedArea != UP) {
      DRAW_WHOLE_FACE(TOP_FACE);
    }
    if (affectedArea != DOWN) {
      DRAW_WHOLE_FACE(BOTTOM_FACE);
    }
  } else {
    int col = affectedArea - FRONT;
    [self loadUniformsWithAnimation:YES];
    DRAW_STICKER_ROW(TOP_FACE, (2 - col));
    DRAW_STICKER_COL(LEFT_FACE, (2 - col));
    DRAW_STICKER_ROW(BOTTOM_FACE, col);
    DRAW_STICKER_COL(RIGHT_FACE, col);
    if (affectedArea == FRONT) {
      DRAW_WHOLE_FACE(FRONT_FACE);
    } else if (affectedArea == BACK) {
      DRAW_WHOLE_FACE(BACK_FACE);
    }
    
    [self loadUniformsWithAnimation:NO];
    DRAW_STICKER_ROW(TOP_FACE, (4 - col) % 3);
    DRAW_STICKER_COL(LEFT_FACE, (4 - col) % 3);
    DRAW_STICKER_ROW(BOTTOM_FACE, (col + 1) % 3);
    DRAW_STICKER_COL(RIGHT_FACE, (col + 1) % 3);
    DRAW_STICKER_ROW(TOP_FACE, (3 - col) % 3);
    DRAW_STICKER_COL(LEFT_FACE, (3 - col) % 3);
    DRAW_STICKER_ROW(BOTTOM_FACE, (col + 2) % 3);
    DRAW_STICKER_COL(RIGHT_FACE, (col + 2) % 3);
    if (affectedArea != FRONT) {
      DRAW_WHOLE_FACE(FRONT_FACE);
    }
    if (affectedArea != BACK) {
      DRAW_WHOLE_FACE(BACK_FACE);
    }
  }
}

- (void)queueRandomMutation
{
  int seed = rand();
  Twist direction = seed % 2 ? NORMAL : PRIME;
  seed = seed >> 1;

  if (seed % 13 < 4) {
    [self startRotation:Rotation(seed % 13)];
  } else {
    Cubelet cubelet = Cubelet(seed % 13 - 4);
    [self startTwist:cubelet direction:direction];
  }
}

- (void)startTwist:(Cubelet)cubelet direction:(Twist)direction
{
  Animation *animation = [Animation new];
  float rad = M_PI_2 * (direction == NORMAL ? 1 : -1);
  if (cubelet >= UP && cubelet <= DOWN) {
    animation.start = GLKQuaternionMakeWithAngleAndAxis(0, 0, 1, 0);
    animation.stop = GLKQuaternionMakeWithAngleAndAxis(rad, 0,- 1, 0);
  } else if (cubelet >= LEFT && cubelet <= RIGHT) {
    animation.start = GLKQuaternionMakeWithAngleAndAxis(0, -1, 0, 0);
    animation.stop = GLKQuaternionMakeWithAngleAndAxis(rad, 1, 0, 0);
  } else {
    animation.start = GLKQuaternionMakeWithAngleAndAxis(0, 0, 0, 1);
    animation.stop = GLKQuaternionMakeWithAngleAndAxis(rad, 0, 0, -1);
  }
  animation.affectedArea = cubelet;
  animation.duration = 0.5;
  animation.doneCallback = 
    [NSInvocation invocationWithTarget:self
        selector:@selector(twistModel:direction:)
        retainArguments:NO, cubelet, direction];
  [_animationQueue enqueueAnimation:animation];
}

-(void) twistModel:(Cubelet)cubelet direction:(Twist)direction
{
  _cube->Twist(cubelet, direction);
  _colorsDirty = YES;
}

- (void)startRotation:(Rotation) direction
{
  Animation *animation = [Animation new];
  switch (direction) {
    case ROT_UP:
      animation.start = GLKQuaternionMakeWithAngleAndAxis(0, 1, 0, 0);
      animation.stop = GLKQuaternionMakeWithAngleAndAxis(M_PI / 2, -1, 0, 0);
      break;
    case ROT_DOWN:
      animation.start = GLKQuaternionMakeWithAngleAndAxis(0, 1, 0, 0);
      animation.stop = GLKQuaternionMakeWithAngleAndAxis(-M_PI / 2, -1, 0, 0);
      break;
    case ROT_LEFT:
      animation.start = GLKQuaternionMakeWithAngleAndAxis(0, 0, 1, 0);
      animation.stop = GLKQuaternionMakeWithAngleAndAxis(M_PI / 2, 0, -1, 0);
      break;
    case ROT_RIGHT:
      animation.start = GLKQuaternionMakeWithAngleAndAxis(0, 0, 1, 0);
      animation.stop = GLKQuaternionMakeWithAngleAndAxis(-M_PI / 2, 0, -1, 0);
      break;
  };
  animation.affectedArea = WHOLE_CUBE;
  animation.duration = 0.5;
  animation.doneCallback = 
      [NSInvocation invocationWithTarget:self
                                selector:@selector(rotateModel:)
                         retainArguments:NO, direction];
  [_animationQueue enqueueAnimation:animation];
}

- (void)rotateModel:(Rotation) direction
{
  _cube->Rotate(direction);
  _colorsDirty = YES;
}

@end
