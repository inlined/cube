//
//  TomsCubeTests.m
//  TomsCubeTests
//
//  Created by Thomas Bouldin on 3/12/12.
//  Copyright (c) 2012 Google. All rights reserved.
//

#import "CubeModelTests.hh"

#define CHECK_FACE(face, ndx, color) \
{ \
  Color actual = c->GetFace(face)[ndx]; \
  STAssertEquals(color, actual, \
       @"Expected the %@ face index %d to be %@ but it was %@", \
       nameForFace(face), ndx, nameForColor(color), nameForColor(actual)); \
}

#define CHECK_SOLVED(isSolved) \
  if (isSolved) \
    STAssertTrue(c->IsSolved(), nil); \
  else \
    STAssertFalse(c->IsSolved(), nil);

NSString* nameForColor(Color color) {
  static NSString* names[] = 
  { @"RED", @"WHITE", @"ORANGE", @"YELLOW", @"GREEN", @"BLUE" };
  
  if (color >= NUM_COLORS) {
    return @"INVALID COLOR";
  }
  return names[color];
}

NSString* nameForFace(WhichFace face) {
  static NSString* names[] =
  { @"front", @"right", @"back", @"left", @"top", @"bottom" };
  if (face >= NUM_FACES) {
    return @"INVALID FACE";
  }
  return names[face];
}

@implementation TomsCubeTests

- (void)setUp
{
  [super setUp];
  c = new Cube();
  up = c->GetFace(TOP_FACE);
  down = c->GetFace(BOTTOM_FACE);
  left = c->GetFace(LEFT_FACE);
  right = c->GetFace(RIGHT_FACE);
  front = c->GetFace(FRONT_FACE);
  back = c->GetFace(BACK_FACE);
}

- (void)tearDown
{
  delete c;
  c = NULL;
    
  [super tearDown];
}

#pragma mark moves

- (void) beSexy {
  c->Twist(RIGHT, NORMAL);
  c->Twist(UP, NORMAL);
  c->Twist(RIGHT, PRIME);
  c->Twist(UP, PRIME);
}

- (void) doMumu
{
  c->Twist(MIDDLE, PRIME);
  c->Twist(UP, NORMAL);
  c->Twist(UP, NORMAL);
  c->Twist(MIDDLE, NORMAL);
  c->Twist(UP, NORMAL);
  c->Twist(UP, NORMAL);
}

- (void) r2d2
{
  c->Twist(RIGHT, NORMAL);
  c->Twist(RIGHT, NORMAL);
  c->Twist(DOWN, PRIME);
  c->Twist(LEFT, NORMAL);
  c->Twist(LEFT, NORMAL);
  c->Twist(DOWN, NORMAL);
  c->Twist(RIGHT, PRIME);
  c->Twist(RIGHT, PRIME);
  c->Twist(DOWN, PRIME);
  c->Twist(LEFT, PRIME);
  c->Twist(LEFT, PRIME);
  c->Twist(DOWN, NORMAL);
}

#pragma end

- (void) testCubeStartsWithCorrectColors
{
  CHECK_FACE(FRONT_FACE, 0, RED);
  CHECK_FACE(BACK_FACE, 0, ORANGE);
  CHECK_FACE(LEFT_FACE, 0, YELLOW);
  CHECK_FACE(RIGHT_FACE, 0, WHITE);
  CHECK_FACE(TOP_FACE, 0, GREEN);
  CHECK_FACE(BOTTOM_FACE, 0, BLUE);
}

- (void) testRotationsAreStillSolved
{
  CHECK_SOLVED(YES);
  c->Rotate(ROT_UP);
  CHECK_SOLVED(YES);
  c->Rotate(ROT_LEFT);
  CHECK_SOLVED(YES);
  c->Rotate(ROT_DOWN);
  CHECK_SOLVED(YES);
  c->Rotate(ROT_RIGHT);
  CHECK_SOLVED(YES);
}

- (void) testBackFaceAfterUpRotation
{
  up[0] = RED;
  up[1] = WHITE;
  up[2] = BLUE;
  up[3] = YELLOW;
  c->Rotate(ROT_UP);
  CHECK_FACE(BACK_FACE, 8, RED);
  CHECK_FACE(BACK_FACE, 7, WHITE);
  CHECK_FACE(BACK_FACE, 6, BLUE);
  CHECK_FACE(BACK_FACE, 5, YELLOW);
}

- (void) testBottomFaceAfterUpRotation
{
  back[8] = RED;
  back[7] = WHITE;
  back[6] = BLUE;
  back[5] = YELLOW;
  c->Rotate(ROT_UP);
  CHECK_FACE(BOTTOM_FACE, 0, RED);
  CHECK_FACE(BOTTOM_FACE, 1, WHITE);
  CHECK_FACE(BOTTOM_FACE, 2, BLUE);
  CHECK_FACE(BOTTOM_FACE, 3, YELLOW);
}

- (void) testSideFacesAfterUpRotation
{
  left[3] = BLUE;
  left[6] = RED;
  left[7] = GREEN;
  left[8] = ORANGE;
  right[5] = BLUE;
  right[8] = RED;
  right[7] = GREEN;
  right[6] = ORANGE;
  c->Rotate(ROT_UP);
  CHECK_FACE(LEFT_FACE, 6, YELLOW);
  CHECK_FACE(LEFT_FACE, 7, BLUE);
  CHECK_FACE(LEFT_FACE, 8, RED);
  CHECK_FACE(LEFT_FACE, 5, GREEN);
  CHECK_FACE(LEFT_FACE, 2, ORANGE);
  CHECK_FACE(RIGHT_FACE, 8, WHITE);
  CHECK_FACE(RIGHT_FACE, 7, BLUE);
  CHECK_FACE(RIGHT_FACE, 6, RED);
  CHECK_FACE(RIGHT_FACE, 3, GREEN);
  CHECK_FACE(RIGHT_FACE, 0, ORANGE);
}

- (void) testBackFaceAfterDownRotation
{
  down[0] = RED;
  down[1] = WHITE;
  down[2] = BLUE;
  down[3] = YELLOW;
  c->Rotate(ROT_DOWN);
  CHECK_FACE(BACK_FACE, 8, RED);
  CHECK_FACE(BACK_FACE, 7, WHITE);
  CHECK_FACE(BACK_FACE, 6, BLUE);
  CHECK_FACE(BACK_FACE, 5, YELLOW);
}

- (void) testTopFaceAfterDownRotation {
  back[8] = RED;
  back[7] = WHITE;
  back[6] = BLUE;
  back[5] = YELLOW;
  c->Rotate(ROT_DOWN);
  CHECK_FACE(TOP_FACE, 0, RED);
  CHECK_FACE(TOP_FACE, 1, WHITE);
  CHECK_FACE(TOP_FACE, 2, BLUE);
  CHECK_FACE(TOP_FACE, 3, YELLOW);
}

- (void) testSideFacesAfterDownRotation
{
  right[3] = BLUE;
  right[6] = RED;
  right[7] = GREEN;
  right[8] = ORANGE;
  left[5] = BLUE;
  left[8] = RED;
  left[7] = GREEN;
  left[6] = ORANGE;
  c->Rotate(ROT_DOWN);
  CHECK_FACE(RIGHT_FACE, 6, WHITE);
  CHECK_FACE(RIGHT_FACE, 7, BLUE);
  CHECK_FACE(RIGHT_FACE, 8, RED);
  CHECK_FACE(RIGHT_FACE, 5, GREEN);
  CHECK_FACE(RIGHT_FACE, 2, ORANGE);
  CHECK_FACE(LEFT_FACE, 8, YELLOW);
  CHECK_FACE(LEFT_FACE, 7, BLUE);
  CHECK_FACE(LEFT_FACE, 6, RED);
  CHECK_FACE(LEFT_FACE, 3, GREEN);
  CHECK_FACE(LEFT_FACE, 0, ORANGE);
}

- (void) testRotLeft
{
  c->Rotate(ROT_LEFT);
  CHECK_FACE(FRONT_FACE, 0, WHITE);
}

- (void)testRotRight
{
  c->Rotate(ROT_RIGHT);
  CHECK_FACE(FRONT_FACE, 0, YELLOW);
}

- (void)testTwistFont
{
  up[6] = YELLOW;
  up[7] = ORANGE;
  left[2] = RED;
  left[5] = ORANGE;
  right[0] = ORANGE;
  right[3] = RED;
  down[0] = RED;
  down[1] = ORANGE;
  c->Twist(FRONT, NORMAL);
  CHECK_FACE(RIGHT_FACE, 0, YELLOW);
  CHECK_FACE(RIGHT_FACE, 3, ORANGE);
  CHECK_FACE(RIGHT_FACE, 6, GREEN);
  
  CHECK_FACE(TOP_FACE, 8, RED);
  CHECK_FACE(TOP_FACE, 7, ORANGE);
  CHECK_FACE(TOP_FACE, 6, YELLOW);
  
  CHECK_FACE(BOTTOM_FACE, 2, ORANGE);
  CHECK_FACE(BOTTOM_FACE, 1, RED);
  CHECK_FACE(BOTTOM_FACE, 0, WHITE);
  
  CHECK_FACE(LEFT_FACE, 2, BLUE);
  CHECK_FACE(LEFT_FACE, 5, ORANGE);
  CHECK_FACE(LEFT_FACE, 8, RED);
  
  // Squares which shouldn't be rotated aren't:
  CHECK_FACE(RIGHT_FACE, 2, WHITE);
  CHECK_FACE(RIGHT_FACE, 5, WHITE);
  CHECK_FACE(RIGHT_FACE, 8, WHITE);
  
  c->Reset();
  up[6] = YELLOW;
  up[7] = ORANGE;
  left[2] = RED;
  left[5] = ORANGE;
  right[0] = ORANGE;
  right[3] = RED;
  down[0] = RED;
  down[1] = ORANGE;
  c->Twist(FRONT, PRIME);
  CHECK_FACE(LEFT_FACE, 8, YELLOW);
  CHECK_FACE(LEFT_FACE, 5, ORANGE);
  CHECK_FACE(LEFT_FACE, 2, GREEN);
  
  CHECK_FACE(BOTTOM_FACE, 0, RED);
  CHECK_FACE(BOTTOM_FACE, 1, ORANGE);
  CHECK_FACE(BOTTOM_FACE, 2, YELLOW);
  
  CHECK_FACE(TOP_FACE, 6, ORANGE);
  CHECK_FACE(TOP_FACE, 7, RED);
  CHECK_FACE(TOP_FACE, 8, WHITE);
  
  CHECK_FACE(RIGHT_FACE, 6, BLUE);
  CHECK_FACE(RIGHT_FACE, 3, ORANGE);
  CHECK_FACE(RIGHT_FACE, 0, RED);
}

- (void)testFaceRotationsAreCorrectForTwists
{
  down[3] = WHITE;
  up[3] = WHITE;
  c->Twist(UP, PRIME);
  CHECK_FACE(FRONT_FACE, 0, YELLOW);
  CHECK_FACE(TOP_FACE, 7, WHITE);
  c->Twist(DOWN, PRIME);
  CHECK_FACE(FRONT_FACE, 6, YELLOW);
  CHECK_FACE(BOTTOM_FACE, 1, WHITE);
  
  
  c->Reset();
  left[5] = BLUE;
  c->Twist(LEFT, NORMAL);
  CHECK_FACE(FRONT_FACE, 0, GREEN);
  CHECK_FACE(LEFT_FACE, 7, BLUE);
  right[3] = BLUE;
  
  c->Twist(RIGHT, NORMAL);
  CHECK_FACE(FRONT_FACE, 2, GREEN);
  CHECK_FACE(RIGHT_FACE, 7, BLUE);
  
  
  c->Reset();
  front[0] = WHITE;
  c->Twist(FRONT, NORMAL);
  CHECK_FACE(TOP_FACE, 7, YELLOW);
  CHECK_FACE(FRONT_FACE, 2, WHITE);
  
  back[0] = WHITE;
  c->Twist(BACK, NORMAL);
  CHECK_FACE(TOP_FACE, 2, YELLOW);
  CHECK_FACE(BACK_FACE, 6, WHITE);
}

- (void)testTwistUp
{
  CHECK_FACE(FRONT_FACE, 0, RED);
  CHECK_FACE(BACK_FACE, 0, ORANGE);
  CHECK_FACE(LEFT_FACE, 0, YELLOW);
  CHECK_FACE(RIGHT_FACE, 0, WHITE);
  c->Twist(UP, PRIME);
  CHECK_FACE(RIGHT_FACE, 0, RED);
  CHECK_FACE(BACK_FACE, 0, WHITE);
  CHECK_FACE(LEFT_FACE, 0, ORANGE);
  CHECK_FACE(FRONT_FACE, 0, YELLOW);
  c->Twist(UP, NORMAL);
  CHECK_FACE(FRONT_FACE, 0, RED);
  CHECK_FACE(BACK_FACE, 0, ORANGE);
  CHECK_FACE(LEFT_FACE, 0, YELLOW);
  CHECK_FACE(RIGHT_FACE, 0, WHITE);
  c->Twist(UP, NORMAL);
  CHECK_FACE(LEFT_FACE, 0, RED);
  CHECK_FACE(FRONT_FACE, 0, WHITE);
  CHECK_FACE(RIGHT_FACE, 0, ORANGE);
  CHECK_FACE(BACK_FACE, 0, YELLOW);
}

- (void) testTwistSymmetry
{
  // Simple prime functions
  CHECK_SOLVED(YES);
  c->Twist(LEFT, NORMAL);
  CHECK_SOLVED(NO);
  c->Twist(LEFT, PRIME);
  CHECK_SOLVED(YES);
  
  c->Twist(MIDDLE, PRIME);
  CHECK_SOLVED(NO);
  c->Twist(MIDDLE, NORMAL);
  CHECK_SOLVED(YES);
  
  c->Twist(RIGHT, NORMAL);
  CHECK_SOLVED(NO);
  c->Twist(RIGHT, PRIME);
  CHECK_SOLVED(YES);
  
  c->Twist(UP, PRIME);
  CHECK_SOLVED(NO);
  c->Twist(UP, NORMAL);
  CHECK_SOLVED(YES);
  
  c->Twist(EQUATOR, NORMAL);
  CHECK_SOLVED(NO);
  c->Twist(EQUATOR, PRIME);
  CHECK_SOLVED(YES);
  
  c->Twist(DOWN, PRIME);
  CHECK_SOLVED(NO);
  c->Twist(DOWN, NORMAL);
  CHECK_SOLVED(YES);
  
  c->Twist(FRONT, NORMAL);
  CHECK_SOLVED(NO);
  c->Twist(FRONT, PRIME);
  CHECK_SOLVED(YES);
  
  c->Twist(STANDING, PRIME);
  CHECK_SOLVED(NO);
  c->Twist(STANDING, NORMAL);
  CHECK_SOLVED(YES);
}

- (void) testTrickyTwists_MiddleUp
{
  front[1] = up[1] = back[7] = down[1] = WHITE;
  front[7] = up[7] = back[1] = down[7] = BLUE;
  c->Twist(MIDDLE, NORMAL);
  CHECK_FACE(FRONT_FACE, 1, WHITE);
  CHECK_FACE(TOP_FACE, 1, WHITE);
  CHECK_FACE(BACK_FACE, 7, WHITE);
  CHECK_FACE(BOTTOM_FACE, 1, WHITE);
  CHECK_FACE(FRONT_FACE, 7, BLUE);
  CHECK_FACE(TOP_FACE, 7, BLUE);
  CHECK_FACE(BACK_FACE, 1, BLUE);
  CHECK_FACE(BOTTOM_FACE, 7, BLUE);
}

- (void) testTrickyTwists_TopRotate
{
  front[0] = right[0] = back[0] = left[0] = GREEN;
  front[2] = right[2] = back[2] = left[2] = BLUE;
  up[0] = RED;
  up[1] = WHITE;
  up[2] = BLUE;
  up[3] = YELLOW;
  c->Twist(UP, PRIME);
  CHECK_FACE(FRONT_FACE, 0, GREEN);
  CHECK_FACE(RIGHT_FACE, 0, GREEN);
  CHECK_FACE(BACK_FACE, 0, GREEN);
  CHECK_FACE(LEFT_FACE, 0, GREEN);
  CHECK_FACE(FRONT_FACE, 2, BLUE);
  CHECK_FACE(RIGHT_FACE, 2, BLUE);
  CHECK_FACE(BACK_FACE, 2, BLUE);
  CHECK_FACE(LEFT_FACE, 2, BLUE);
  CHECK_FACE(TOP_FACE, 1, GREEN);
  CHECK_FACE(TOP_FACE, 0, BLUE);
  CHECK_FACE(TOP_FACE, 3, WHITE);
  CHECK_FACE(TOP_FACE, 6, RED);
  CHECK_FACE(TOP_FACE, 7, YELLOW);
}

- (void) testMumu
  {
  [self doMumu];
  CHECK_FACE(FRONT_FACE, 1, ORANGE);
  CHECK_FACE(FRONT_FACE, 7, RED);
  CHECK_FACE(TOP_FACE, 7, GREEN);
  CHECK_FACE(TOP_FACE, 1, BLUE);
  CHECK_FACE(BOTTOM_FACE, 1, GREEN);
  CHECK_FACE(BOTTOM_FACE, 7, BLUE);
}
  
- (void) testComplextTwistInverses
{
  CHECK_SOLVED(YES);
  [self doMumu];
  CHECK_SOLVED(NO);
  c->Rotate(ROT_RIGHT);
  c->Rotate(ROT_RIGHT);
  c->Rotate(ROT_DOWN);
  [self doMumu];
  CHECK_SOLVED(YES);
}

- (void) testTwistCycles
{
  [self doMumu];
  CHECK_SOLVED(NO);
  [self doMumu];
  CHECK_SOLVED(NO);
  [self doMumu];
  CHECK_SOLVED(YES);
  
  [self r2d2];
  CHECK_SOLVED(NO);
  [self r2d2];
  CHECK_SOLVED(NO);
  [self r2d2];
  CHECK_SOLVED(YES);
  
  [self beSexy];
  CHECK_SOLVED(NO);
  [self beSexy];
  CHECK_SOLVED(NO);
  [self beSexy];
  CHECK_SOLVED(NO);
  [self beSexy];
  CHECK_SOLVED(NO);
  [self beSexy];
  CHECK_SOLVED(NO);
  [self beSexy];
  CHECK_SOLVED(YES);
}

@end
