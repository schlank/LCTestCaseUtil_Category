//
//  XCTestCase+LCTestCaseUtil.m
//  WON-F4W
//
//  Created by Philip Leder on 2/21/14.
//  Copyright (c) 2014 Leder Consulting. All rights reserved.
//

#import "XCTestCase+LCTestCaseUtil.h"
#import "MyCategoryIVars.h"
#import "LCMainVC.h"

@implementation XCTestCase (LCTestCaseUtil)

- (LCLiveShowMainViewController*)getMainViewController
{
    LCAppDelegate *appDelegate = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
    LCLiveShowMainViewController *mainController = (LCLiveShowMainViewController*)appDelegate.window.rootViewController;
    return mainController;
}

- (LCRadioStreamController*)getRadioViewController
{
    LCLiveShowMainViewController *mainController = [self getMainViewController];
    LCRadioStreamController *radioController = (LCRadioStreamController*)[[mainController childViewControllers] objectAtIndex:0];
    return radioController;
}

- (LCSocialViewController*)getSocialViewController
{
    LCLiveShowMainViewController *mainController = [self getMainViewController];
    NSArray *childViews = [mainController childViewControllers];
    
    LCMainVC *mainViewController = [childViews objectAtIndex:0];
    
    NSLog(@"LCMainVC mainViewController:%@", mainViewController);
    
    
    
    return (LCSocialViewController*)mainController.socialContainerView;
//    if(![self waitForBlock:^BOOL{
//        NSLog(@"childViews:%@", childViews);
//        return [childViews count]>1;
//    } withTimeout:3])
//    {
//        return nil;
//    }
//    NSLog(@"childViews2:%@", childViews);
//    
//    return (LCSocialViewController*)[childViews objectAtIndex:1];;
}

- (UIAlertView*)getTopMostAlertView
{
    __block UIAlertView *topMostAlert = nil;
    Class alertManagerClass = NSClassFromString(@"_UIAlertManager");
    if([alertManagerClass respondsToSelector:NSSelectorFromString(@"topMostAlert")])
    {
//        [self waitForBlock:^BOOL{
            SuppressPerformSelectorLeakWarning(topMostAlert = [alertManagerClass performSelector:NSSelectorFromString(@"topMostAlert")];);
//            return topMostAlert != nil;
//        } withTimeout:1];
    }
    else
    {
        XCTFail(@"The UIAlertView may have changed and this test needs to be updated.");
    }
    return topMostAlert;
}

#pragma Waiting For Blocks

- (BOOL)waitForBlock:(BOOL (^)(void))taskDone withTimeout:(NSTimeInterval)timeoutSecs withMessage:(NSString*)messageStr
{
    BOOL doneLooping = NO;
    BOOL taskIsDone = NO;
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    do
    {
        taskIsDone = taskDone();
        if(taskIsDone)
        {
            NSLog(@"waitForBlock Break because TASK is DONE");
            doneLooping = YES;
            break;
        }
        if([timeoutDate timeIntervalSinceNow] < 0.0)
        {
            NSLog(@"waitForBlock TIMED OUT in timeoutSecs:%f", timeoutSecs);
            doneLooping = YES;
            break;
        }
        NSLog(@"Test waitForBlock waiting taskDone():%@ timeoutSecs:%f", (taskDone() ? @"YES" : @"NO"), timeoutSecs);
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    }
    while (!doneLooping);
    if(!taskIsDone)
    {
        NSLog(@"%@ %@ timeout:%f", [NSThread callStackSymbols], messageStr, timeoutSecs);
    }
    return taskIsDone;
}

- (BOOL)waitForBlock:(BOOL (^)(void))taskDone withTimeout:(NSTimeInterval)timeoutSecs
{
    NSString *messageStr = @"WaitForBlock. Task or state timedout or returned FALSE";
    return [self waitForBlock:taskDone withTimeout:timeoutSecs withMessage:messageStr];
}

- (void)waitForSeconds:(NSTimeInterval)timeoutSecs
{
    
    BOOL doneLooping = NO;
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    if(!timeoutDate)
    {
        return;
    }
    do
    {
        if([timeoutDate timeIntervalSinceNow] < 0.0)
        {
            doneLooping = YES;
            break;
        }
        NSLog(@"waitForSeconds:%f Running", timeoutSecs);
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    }
    while (!doneLooping);
    NSLog(@"doneLooping from %f seconds",timeoutSecs);
}

#pragma Swizzling

- (void)replaceImplementationOfSelector:(NSString*)selString ofClass:(Class)mockedClass withSelectorString:(NSString*)srcSelString
{
    Swizzler *methodSwizzler = [Swizzler new];
    [methodSwizzler swapImplementationOfSelector:selString ofClass:mockedClass withSelectorString:srcSelString ofClass:[self class]];
    [self registerSwizzle:methodSwizzler];
}

- (void)replaceImplementationOfSelector:(NSString*)selString ofClass:(Class)mockedClass withSelector:(SEL)srcSelector
{
    Swizzler *methodSwizzler = [Swizzler new];
    [methodSwizzler swapImplementationOfSelector:selString ofClass:mockedClass withSelector:srcSelector ofClass:[self class]];
    [self registerSwizzle:methodSwizzler];
}

- (BOOL)mockYES
{
    return YES;
}

- (BOOL)mockNO
{
    return NO;
}

- (void)stub {
    
    NSLog(@"Method STUBBED! - %s", __PRETTY_FUNCTION__);
    return;
    
} //stubbed out, does nothing.

- (void)registerSwizzle:(id)swizzle
{
    BOOL respondsToDeSwizzle = [swizzle respondsToSelector:@selector(deswizzle)];
    if(!respondsToDeSwizzle)
    {
        NSLog(@"WAVETestUtil registerSwizzle failed does not response to deswizzle");
        return;
    }
    NSMutableArray *currentSwizzles = [MyCategoryIVars fetch:self].swizzles;
    NSLog(@"Swizzle Registered:%@",[swizzle class]);
    [currentSwizzles addObject:swizzle];
}

- (void)setSwizzles:(NSMutableArray *)swizzles
{
    [MyCategoryIVars fetch:self].swizzles = swizzles;
}

- (NSMutableArray*)swizzles
{
    return [MyCategoryIVars fetch:self].swizzles;
}

- (void)deswizzleAll
{
    NSLog(@"deswizzleAll");
    NSMutableArray *allSwizzles = [MyCategoryIVars fetch:self].swizzles;
    for(int x=0; x<allSwizzles.count;x++)
    {
        Swizzler *currentSwizzle = [allSwizzles objectAtIndex:x];
        NSLog(@"XCTestCase deswizzle %i",x);
        [currentSwizzle deswizzle];
    }
    [self setSwizzles:[NSMutableArray array]];
}

#pragma Util Functions

- (void)utilTearDown
{
    UIAlertView *topMostAlert = [self getTopMostAlertView];
    if(topMostAlert && [topMostAlert isVisible])
    {
        [topMostAlert dismissWithClickedButtonIndex:0 animated:NO];
        topMostAlert = nil;
    }
    [self deswizzleAll];
}

-(UIAlertView*)showWithError:(NSError*) error
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[error localizedDescription]
                          message:[error localizedRecoverySuggestion]
                          delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                          otherButtonTitles:nil];
    
    [alert show];
    return alert;
}

#pragma response object

-(void)assertCorrectResponseObject:(id)responseObject
{
    //    NSLog(@"CLASS:%@ responseObject:%@ ", [responseObject class], responseObject);
    [self logResponseObject:responseObject];
    if(responseObject == nil)
    {
        XCTAssertNotNil(responseObject, @"responseObject nil");
        return;
    }
    BOOL responseIsArray = ([[responseObject class]isSubclassOfClass:[NSArray class]]);
    XCTAssertTrue(responseIsArray, @"Response Object is of wrong type.  Actual:%@",[responseObject class]);
    if(responseIsArray)
    {
        XCTAssertTrue(([responseObject count]>0), @"Array Response empty");
    }
}

-(void)logResponseObject:(id)responseObject
{
    NSString *responseString = @"";
    if(!responseObject){
        NSLog(@"Response Nil.");
        return;}
    if([[responseObject class]isSubclassOfClass:[NSArray class]])
    {
        responseString = [NSString stringWithFormat:@"\n\nRESPONSE ARRAY: \n ->returned with count:%i \n\n", [responseObject count]];
    }
    else
    {
        responseString = [NSString stringWithFormat:@"%@", responseObject];
    }
    NSLog(@"%@",responseString);
}

@end
