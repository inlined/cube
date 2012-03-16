//
//  NSInvocation+Shorthand.h
//  TomsCube
//
//  Created by Thomas Bouldin on 3/15/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (Shorthand)
+ (NSInvocation*)invocationWithTarget:(id)target
                             selector:(SEL)aSelector
                      retainArguments:(BOOL)retainArguments, ...;
@end
