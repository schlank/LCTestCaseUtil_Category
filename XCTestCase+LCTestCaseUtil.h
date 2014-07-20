//
//  XCTestCase+LCTestCaseUtil.h
//  WON-F4W
//
//  Created by Philip Leder on 2/21/14.
//  Copyright (c) 2014 Leder Consulting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LCLiveShowMainViewController.h"
#import "LCRadioStreamController.h"
#import "LCSocialViewController.h"
#import "LCAppDelegate.h"
#import "Swizzler.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface XCTestCase (LCTestCaseUtil)

#pragma View Controller Getters
- (LCLiveShowMainViewController*)getMainViewController;
- (LCRadioStreamController*)getRadioViewController;
- (LCSocialViewController*)getSocialViewController;
- (UIAlertView*)getTopMostAlertView;

#pragma Waiting For Blocks
- (void)waitForSeconds:(NSTimeInterval)timeoutSecs;
- (BOOL)waitForBlock:(BOOL (^)(void))taskDone withTimeout:(NSTimeInterval)timeoutSecs;
- (BOOL)waitForBlock:(BOOL (^)(void))taskDone withTimeout:(NSTimeInterval)timeoutSecs withMessage:(NSString*)messageStr;

#pragma Swizzling

- (void)replaceImplementationOfSelector:(NSString*)selString ofClass:(Class)mockedClass withSelectorString:(NSString*)srcSelString;
- (void)replaceImplementationOfSelector:(NSString*)selString ofClass:(Class)mockedClass withSelector:(SEL)srcSelector;
- (BOOL)mockYES;
- (BOOL)mockNO;
- (void)deswizzleAll;

#pragma Util Functions
- (void)utilTearDown;
- (UIAlertView*)showWithError:(NSError*) error;

#pragma response object

-(void)assertCorrectResponseObject:(id)responseObject;
-(void)logResponseObject:(id)responseObject;

@end
