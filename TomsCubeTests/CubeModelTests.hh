//
//  TomsCubeTests.h
//  TomsCubeTests
//
//  Created by Thomas Bouldin on 3/12/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CubeModel.h"

@interface TomsCubeTests : SenTestCase {
  Cube *c;
  Cube::Face up;
  Cube::Face down;
  Cube::Face left;
  Cube::Face right;
  Cube::Face front;
  Cube::Face back;
}

@end
