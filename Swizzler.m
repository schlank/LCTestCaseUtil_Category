//
//  Swizzler.m
//  WAVE
//
//  Created by Philip Leder on 11/21/13.
//  Copyright (c) 2013 Twisted Pair Solutions. All rights reserved.
//

#import "Swizzler.h"

#pragma mark - SWIZZLER

//(Phil)The Swizzler.  Swaps function implementations at runtime.  NOTE:Only For testing!!!!
@implementation Swizzler
{
    Method originalMethod;
    Method swizzleMethod;
}

/**
 Swaps the implementation of an existing Instance method with the corresponding method in the swizzleClass.
 */
- (void)swizzleInstanceMethod:(Class)targetClass selector:(SEL)selector swizzleClass:(Class)swizzleClass
{
    NSLog(@"(Phil) You are Swizzling an Instance method!  Don't forget to deswizzle ->[%@]<- when you are done!", targetClass);
    originalMethod = class_getInstanceMethod(targetClass, selector);
    swizzleMethod = class_getInstanceMethod(swizzleClass, selector);
	
    if (class_addMethod(targetClass, selector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod)))
    {
        class_replaceMethod(targetClass, selector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        //        method_exchangeImplementations(originalMethod, overrideMethod);
        method_exchangeImplementations(originalMethod, swizzleMethod); // perform the swap, replacing the original with the swizzle method implementation.
    }
}

/**
Adds the implementation of an existing Instance method with the corresponding method in the swizzleClass.
*/
- (void)addInstanceMethod:(Class)targetClass selector:(SEL)selector swizzleClass:(Class)swizzleClass
{
    NSLog(@"(Phil) You are Swizzling an Instance method!  Don't forget to deswizzle ->[%@]<- when you are done!", targetClass);

    originalMethod = class_getInstanceMethod(targetClass, selector);
    swizzleMethod = class_getInstanceMethod(swizzleClass, selector);
    
    if (class_addMethod(targetClass, selector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod)))
    {
        class_replaceMethod(targetClass, selector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
}

- (void)swapImplementationOfSelector:(NSString*)targetSelectorStr ofClass:(Class)targetClass withSelectorString:(NSString*)srcSelStr ofClass:(Class)srcClass
{
    Method srcMethod = class_getInstanceMethod(srcClass, NSSelectorFromString(srcSelStr));
    swizzleMethod = srcMethod;
    IMP srcImp = method_getImplementation(srcMethod);
    
    Method targetMethod = class_getInstanceMethod(targetClass, NSSelectorFromString(targetSelectorStr));
    originalMethod = targetMethod;
    method_setImplementation(targetMethod, srcImp);
    //May be the same as using this method_exchangeImplementations(swizzleMethod, originalMethod);
}

- (void)swapImplementationOfSelector:(NSString*)targetSelectorStr ofClass:(Class)targetClass withSelector:(SEL)srcSelector ofClass:(Class)srcClass
{
    Method srcMethod = class_getInstanceMethod(srcClass, srcSelector);
    swizzleMethod = srcMethod;
    IMP srcImp = method_getImplementation(srcMethod);
    
    Method targetMethod = class_getInstanceMethod(targetClass, NSSelectorFromString(targetSelectorStr));
    originalMethod = targetMethod;
    method_setImplementation(targetMethod, srcImp);
    //May be the same as using this method_exchangeImplementations(swizzleMethod, originalMethod);
}

//- (void)swapImplementationOfSelector:(SEL)targetSelector ofClass:(Class)targetClass withImplementation:(IMP)newImplementation
//{
////    IMP imp1 = method_getImplementation(m1);
////    IMP imp2 = method_getImplementation(m2);
////    method_setImplementation(m1, imp2);
////    method_setImplementation(m2, imp1);
//    Method targetMethod = class_getClassMethod(targetClass, targetSelector);
//    method_setImplementation(targetMethod, newImplementation);
//}

/**
 Swaps the implementation of an existing Instance method with the corresponding method in the swizzleClass.
 */
- (void)swizzleClassMethod:(Class)targetClass selector:(SEL)selector swizzleClass:(Class)swizzleClass
{
    NSLog(@"(Phil) You are Swizzling a Class method!  Don't forget to deswizzle ->[%@]<- when you are done!", targetClass);
    originalMethod = class_getClassMethod(targetClass, selector);
    swizzleMethod = class_getClassMethod(swizzleClass, selector);
	
    if (class_addMethod(targetClass, selector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod)))
    {
        class_replaceMethod(targetClass, selector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        //        method_exchangeImplementations(originalMethod, overrideMethod);
        method_exchangeImplementations(originalMethod, swizzleMethod); // perform the swap, replacing the original with the swizzle method implementation.
    }
}

/**
 Restores the implementation of an existing class method with its original implementation.
 */
- (void)deswizzle
{
    if(!swizzleMethod || !originalMethod)
    {
        return;
    }
    NSLog(@"Back To:%@",NSStringFromSelector(method_getName(originalMethod)));
    NSLog(@"From:%@",NSStringFromSelector(method_getName(swizzleMethod)));
    
	method_exchangeImplementations(swizzleMethod, originalMethod); // perform the swap, replacing the previously swizzled method with the original implementation.
	swizzleMethod = nil;
	originalMethod = nil;
}

@end