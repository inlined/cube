//
//  NSInvocation+Shorthand.m
//  TomsCube
//
//  Created by Thomas Bouldin on 3/15/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

#import "NSInvocation+Shorthand.h"

@implementation NSInvocation (Shorthand)
+ (NSInvocation*)invocationWithTarget:(id)target
                             selector:(SEL)aSelector
                      retainArguments:(BOOL)retainArguments, ...
{
  va_list ap;
  va_start(ap, retainArguments);
  char* args = (char*)ap;
  NSMethodSignature* signature = [target methodSignatureForSelector:aSelector];
  NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
  if (retainArguments) {
    [invocation retainArguments];
  }
  [invocation setTarget:target];
  [invocation setSelector:aSelector];
  for (int index = 2; index < [signature numberOfArguments]; index++) {
    const char *type = [signature getArgumentTypeAtIndex:index];
    NSUInteger size, align;
    NSGetSizeAndAlignment(type, &size, &align);
    NSUInteger mod = (NSUInteger)args % align;
    if (mod != 0) {
      args += (align - mod);
    }
    [invocation setArgument:args atIndex:index];
    args += size;
  }
  va_end(ap);
  return invocation;
}
@end 

