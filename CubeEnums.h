//
//  CubeEnums.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/15/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#ifndef TomsCube_CubeEnums_h
#define TomsCube_CubeEnums_h

// Color enums are defined as 4 redundant bytes of an index into color codes.
// This allows byte blasting as each byte will describe a different vertex of
// the sticker face
typedef enum {
  RED,
  WHITE,
  ORANGE,
  YELLOW,
  GREEN,
  BLUE,
  NUM_COLORS
} Color;

// Index into a cube a Face * 9 to get the start index.
typedef enum {
  FRONT_FACE,
  RIGHT_FACE,
  BACK_FACE,
  LEFT_FACE,
  TOP_FACE,
  BOTTOM_FACE,
  NUM_FACES
} WhichFace;

typedef enum {
  FRONT,
  STANDING,
  BACK,
  UP,
  EQUATOR,
  DOWN,
  LEFT,
  MIDDLE,
  RIGHT,
  WHOLE_CUBE  // Used for animation codes.
} Cubelet;
typedef enum { NORMAL, PRIME } Twist;
typedef enum { ROT_UP, ROT_DOWN, ROT_LEFT, ROT_RIGHT } Rotation;

#endif
