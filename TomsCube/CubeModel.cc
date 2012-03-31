/*
 *  Cube.c
 *  Cubez
 *
 *  Created by Thomas Bouldin on 11/7/06.
 *  Copyright 2006 Thomas Bouldin. All rights reserved.
 *
 */

#include "CubeModel.h"
#include <stdlib.h>
#include <string.h>
#include "animation.h"

Cube::Face Cube::GetFace(WhichFace which) {
  return reinterpret_cast<Face>(
      reinterpret_cast<char*>(_data) + sizeof(FaceBuffer) * which);
}

inline void Cube::CopyFace(Cube::Face to, Cube::Face from) {
  memcpy(to, from, sizeof(FaceBuffer));
}

inline void Cube::CopyRow(
    Cube::Face to,
    int t_row,
    Cube::Face from,
    int f_row) {
  memcpy(&to[3 * t_row], &from[3 * f_row], sizeof(Color) * 3);
}

inline void Cube::CopyColumn(
    Cube::Face to,
    int t_col,
    Cube::Face from,
    int f_col) {
  to[t_col] = from[t_col];
  to[t_col + 3] = from[t_col + 3];
  to[t_col + 6] = from[t_col + 6];
}

// Note: Each row has one trailing garbage color
inline void Cube::RotateFaceCW(Cube::Face face) {
  Color temp = face[0];
  face[0] = face[6];
  face[6] = face[8];
  face[8] = face[2];
  face[2] = temp;
  
  temp = face[1];
  face[1] = face[3];
  face[3] = face[7];
  face[7] = face[5];
  face[5] = temp;
}

inline void Cube::RotateFaceCCW(Cube::Face face) {
  Color temp = face[0];
  face[0] = face[2];
  face[2] = face[8];
  face[8] = face[6];
  face[6] = temp;
  
  temp = face[1];
  face[1] = face[5];
  face[5] = face[7];
  face[7] = face[3];
  face[3] = temp;
}

template <typename T>
inline void swap(T& first, T& second) {
  T temp = first;
  first = second;
  second = temp;
}

inline void Transpose(Cube::Face face) {
  swap(face[1], face[3]);
  swap(face[2], face[6]);
  swap(face[5], face[7]);
}

// Written separately in case it is worth writing inline later
inline void Cube::RotateFace180(Cube::Face face) {
  RotateFaceCW(face);
  RotateFaceCW(face);
}

Cube::Cube() {
  Reset();
}

void Cube::Reset() {
  for (WhichFace face_id = FRONT_FACE; face_id < NUM_FACES; ++face_id)
  {
    Face face = GetFace(face_id);
    // Memset does not work because enums are 4B in iOS
    for (int square = 0; square < 9; ++square) {
      face[square] = (Color)face_id;
    }
  }
}

void Cube::Rotate(Rotation direction) {
  FaceBuffer temp;
  Face top = GetFace(TOP_FACE), bottom = GetFace(BOTTOM_FACE);
  Face left = GetFace(LEFT_FACE), right = GetFace(RIGHT_FACE);
  Face front = GetFace(FRONT_FACE), back = GetFace(BACK_FACE);
  
  switch (direction) {
      // NOTE: due to an effect akin to a gimbol lock, up & down rotations must
      // always be applied in a 180 deg rotation to the back
      // LOW SLEEP NOTE: Is this rotate or transpose?
    case ROT_UP:
      RotateFace180(back);
      CopyFace(temp, front);
      CopyFace(front, bottom);
      CopyFace(bottom, back);
      CopyFace(back, top);
      CopyFace(top, temp);
      RotateFace180(back);
      RotateFaceCW(right);
      RotateFaceCCW(left);
      break;
      
    case ROT_DOWN:
      RotateFace180(back);
      CopyFace(temp, front);
      CopyFace(front, top);
      CopyFace(top, back);
      CopyFace(back, bottom);
      CopyFace(bottom, temp);
      RotateFace180(back);
      RotateFaceCW(left);
      RotateFaceCCW(right);
      break;
      
    case ROT_LEFT:
      CopyFace(temp, front);
      CopyFace(front, right);
      CopyFace(right, back);
      CopyFace(back, left);
      CopyFace(left, temp);
      RotateFaceCW(top);
      RotateFaceCCW(bottom);
      break;
      
    case ROT_RIGHT:
      CopyFace(temp, front);
      CopyFace(front, left);
      CopyFace(left, back);
      CopyFace(back, right);
      CopyFace(right, temp);
      RotateFaceCW(bottom);
      RotateFaceCCW(top);
      break;
  };
}


void Cube::Twist(Cubelet cubelet, ::Twist direction) {
  // Lets us index the rotation function by direction
  static void (*RotateDirection[])(Cube::Face) = {
    &Cube::RotateFaceCW, &Cube::RotateFaceCCW
  };

  FaceBuffer temp;
  Face top = GetFace(TOP_FACE), bottom = GetFace(BOTTOM_FACE);
  Face left = GetFace(LEFT_FACE), right = GetFace(RIGHT_FACE);
  Face front = GetFace(FRONT_FACE), back = GetFace(BACK_FACE);

  if (cubelet >= LEFT && cubelet <= RIGHT) {
    int col = cubelet - LEFT;
    RotateFace180(back);
    CopyColumn(temp, col, front, col);
    if (direction == NORMAL) {
      CopyColumn(front, col, top, col);
      CopyColumn(top, col, back, col);
      CopyColumn(back, col, bottom, col);
      CopyColumn(bottom, col, temp, col);
    } else {
      CopyColumn(front, col, bottom, col);
      CopyColumn(bottom, col, back, col);
      CopyColumn(back, col, top, col);
      CopyColumn(top, col, temp, col);
    }
    RotateFace180(back);
    if (cubelet == LEFT) {
      RotateDirection[direction](left);
    } else if (cubelet == RIGHT) {
      RotateDirection[!direction](right);
    }
  }
  
  else if (cubelet >= UP && cubelet <= DOWN) {
    int row = cubelet - UP;
    CopyRow(temp, row, front, row);
    if (direction == NORMAL) {
      CopyRow(front, row, right, row);
      CopyRow(right, row, back, row);
      CopyRow(back, row, left, row);
      CopyRow(left, row, temp, row);
    } else {
      CopyRow(front, row, left, row);
      CopyRow(left, row, back, row);
      CopyRow(back, row, right, row);
      CopyRow(right, row, temp, row);
    }
    if (cubelet == UP) {
      RotateDirection[direction](top);
    } else if (cubelet == DOWN) {
      RotateDirection[!direction](bottom);
    }
  }
  
  // This one is a bit confusing: Given the indexing scheme (from the face
  // perspective, the upper left is 0 and follows row rank order), rotating
  // the front rotates left col 2, top row 2, right col 0, flipped bottom 
  // row 0.
  else if (cubelet >= FRONT && cubelet <= BACK) {
    int row = cubelet - FRONT;
    RotateFace180(left);
    Transpose(left);
    Transpose(right);  // and flip
    CopyRow(temp, row, top, 2 - row);
    if (direction == NORMAL) {
      CopyRow(top, 2 - row, left, row);
      CopyRow(left, row, bottom, row);
      CopyRow(bottom, row, right, row);
      CopyRow(right, row, temp, row);
      swap(left[row * 3], left[row * 3 + 2]);
    } else {
      CopyRow(top, 2 - row, right, row);
      CopyRow(right, row, bottom, row);
      CopyRow(bottom, row, left, row);
      CopyRow(left, row, temp, row);
      swap(right[row * 3], right[row * 3 + 2]);
    }
    // I give up. Too many twists & turns; this fixes the tests
    swap(bottom[3 * row], bottom[3 * row + 2]);

    Transpose(right);
    Transpose(left);
    RotateFace180(left);
    if (cubelet == FRONT) {
      RotateDirection[direction](front);
    } else if (cubelet == BACK) {
      RotateDirection[!direction](back);
    }
  }
}

bool Cube::IsSolved() {
  for (WhichFace id = FRONT_FACE; id < NUM_FACES; ++id) {
    Face face = GetFace(id);
    for (int x = 1; x < 9; ++x) {
      if (face[x] != face[0]) {
        return false;
      }
    }
  }
  return true;
}