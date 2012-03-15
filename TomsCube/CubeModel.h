/*
 *  Cube.h
 *  Tom's Cube
 *
 *  Created by Thomas Bouldin on 11/7/06.
 *  Copyright 2006 Thomas Bouldin. All rights reserved.
 *  A tightly packed array representation of a 3x3 cube of colors.
 *  This model defers the actual placement, size, shape, etc of a square to the
 *  view.
 */

#ifndef CUBE_H
#define CUBE_H

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

class Cube {
public:
  typedef Color* Face;
  
  Cube();
  void Twist(Cubelet cubelet, Twist direction);
  void Rotate(Rotation direction);
  
  // Each face exists in its own object space indexed in row rank order
  Face GetFace(WhichFace which);
  bool IsSolved();
  const Color* raw_buffer() { return _data; }
  
protected:
  static void CopyFace(Face to, Face from);
  static void CopyRow(Face to, int t_row, Face from, int f_row);
  static void CopyColumn(Face to, int t_col, Face from, int f_col);
  
  // All rotations are from face perspective
  static void RotateFaceCW(Face face);
  static void RotateFaceCCW(Face face);
  static void RotateFace180(Face face);
  
private:
  typedef Color FaceBuffer[9];
  Color _data[NUM_FACES * 9];
};

#endif