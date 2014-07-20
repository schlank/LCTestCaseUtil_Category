//
//  Swizzler.h
//  WAVE
//
//  Created by Philip Leder on 11/21/13.
//  Copyright (c) 2013 Twisted Pair Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h> // Needed for method swizzling

@interface Swizzler : NSObject

- (void)swizzleClassMethod:(Class)target_class selector:(SEL)selector swizzleClass:(Class)swizzleClass;
- (void)swizzleInstanceMethod:(Class)target_class selector:(SEL)selector swizzleClass:(Class)swizzleClass;
- (void)addInstanceMethod:(Class)targetClass selector:(SEL)selector swizzleClass:(Class)swizzleClass;
- (void)swapImplementationOfSelector:(NSString*)targetSelectorStr ofClass:(Class)targetClass withSelectorString:(NSString*)srcSelStr ofClass:(Class)srcClass;
- (void)swapImplementationOfSelector:(NSString*)targetSelectorStr ofClass:(Class)targetClass withSelector:(SEL)srcSelector ofClass:(Class)srcClass;

- (void)deswizzle;

@end