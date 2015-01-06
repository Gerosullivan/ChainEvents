//
//  GOCurrentTimersState.h
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 18/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//
// This Class records the state of the app as the user
// interacts with timers.

#import <Foundation/Foundation.h>
@class GOTimer;

@interface GOTimersState : NSObject

+ (instancetype)currentState;

@property (nonatomic) NSInteger currentTimerIndex;
@property (nonatomic) NSInteger timerOrderIndex;
@property (nonatomic) BOOL isActive;
@property (nonatomic) NSInteger countdownRemaining;
@property (nonatomic) BOOL createdFirstTimer;
@property (nonatomic) BOOL shownAllCoachMarks;

- (void)saveState;

@end
