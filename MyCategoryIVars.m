//
//  MyCategoryIVars.h
//  (Phil) A work around to getting member variables for Objective-C Categories.
//  Modified from:
//  http://stackoverflow.com/questions/4146183/instance-variables-for-objective-c-categories
//
//  (Phil) Created so that we could register swizzles of runtime functions in order to make sure we deswizzle
//  when the test ended on logoutTeardown of the WAVETestUtil XCTestCase Category.
//
//  WAVE
//
//  Created by Philip Leder on 11/23/13.
//  Copyright (c) 2013 Twisted Pair Solutions. All rights reserved./
//

#import "MyCategoryIVars.h"
#import <objc/runtime.h>

@implementation MyCategoryIVars

@synthesize swizzles;
@synthesize currentLoggedinPlist;

+ (MyCategoryIVars*)fetch:(id)targetInstance
{
    static void *compactFetchIVarKey = &compactFetchIVarKey;
    MyCategoryIVars *ivars = objc_getAssociatedObject(targetInstance, &compactFetchIVarKey);
    if (ivars == nil) {
        ivars = [[MyCategoryIVars alloc] init];
        objc_setAssociatedObject(targetInstance, &compactFetchIVarKey, ivars, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return ivars;
}

- (id)init
{
    self = [super init];
    self.swizzles = [NSMutableArray array];
    self.currentLoggedinPlist = nil;
    return self;
}

@end