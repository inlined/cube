//
//  ViewController.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/12/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import "SceneView.hh"
#import "ModelView.hh"
#import "SpinningBoxView.h"
#import "CubeView.hh"

@interface SceneView () {
  ModelView* _model_view;
}

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation SceneView

@synthesize context = _context;
@synthesize effect = _effect;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  
  GLKView *view = (GLKView *)self.view;
  view.context = self.context;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  
  [self setupGL];
}

- (void)viewDidUnload
{    
  [super viewDidUnload];
  
  [self tearDownGL];
  
  if ([EAGLContext currentContext] == self.context) {
    [EAGLContext setCurrentContext:nil];
  }
	self.context = nil;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  BOOL will_turn;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    will_turn = (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
    will_turn = YES;
  }
  return _aspectRatioDirty = will_turn;
}

- (void)setupGL
{
  [EAGLContext setCurrentContext:self.context];
  _model_view = [CubeView new];
  _model_view.scene = self;
  [_model_view setupGL];
  
  self.effect = [[GLKBaseEffect alloc] init];
  self.effect.light0.enabled = GL_TRUE;
  self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
  
  glEnable(GL_DEPTH_TEST);
  _aspectRatioDirty = YES;
}

- (void)tearDownGL
{
  [EAGLContext setCurrentContext:self.context];
  [_model_view tearDownGL];
  self.effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
  if (_aspectRatioDirty) {
    NSLog(@"Recalculating projection matrix");
    _aspectRatioDirty = NO;
    float aspect = fabsf(self.view.bounds.size.width / 
                         self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
  }
  [_model_view update];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
  //glClearColor(0, 0, 0, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  //[self.effect prepareToDraw];
  [_model_view glkView:view drawInRect:rect];
}

-(void)addModel:(id)modelView
{}
@end
