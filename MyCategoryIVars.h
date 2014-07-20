//
//  CompactIvars.h
//  WAVE
//
//  Created by Philip Leder on 11/23/13.
//  Copyright (c) 2013 Twisted Pair Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MyCategoryIVars : NSObject

//@property (assign,nonatomic) NSUInteger someObject;
@property (retain,nonatomic) NSMutableArray *swizzles;
@property (retain,nonatomic) NSString *currentLoggedinPlist;
//@property (retain,nonatomic) WTCClientMock *clientMock;

+ (MyCategoryIVars*)fetch:(id)targetInstance;

@end