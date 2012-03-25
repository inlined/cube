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

#include "CubeEnums.h"

class Cube {
public:
  typedef Color* Face;
  
  Cube();
  void Reset();
  
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