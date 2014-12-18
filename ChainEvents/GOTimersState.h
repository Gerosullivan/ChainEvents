//
//  GOCurrentTimersState.h
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 18/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GOTimer;

@interface GOTimersState : NSObject

+ (instancetype)currentState;

@property (nonatomic) GOTimer *currentTimer;
@property (nonatomic) NSUInteger currentTimerIndex;
@property (nonatomic) BOOL isActive;
@property (nonatomic) NSInteger currentRepeat;
@property (nonatomic) NSInteger countdownRemaining;

- (void)newTimer:(GOTimer *)timerObject;

@end
