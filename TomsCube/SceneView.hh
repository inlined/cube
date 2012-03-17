//
//  ViewController.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/12/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface SceneView : GLKViewController<UIGestureRecognizerDelegate> {
  bool _aspectRatioDirty;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

-(void)setupGL;
-(void)tearDownGL;

// TODO: Add more detail about positioning, scale, and orientation. Consider
// moving back to pure ObjC when the controller can inject a CubeView directly
-(void)addModel:(id)modelView;
@end
