//
//  GOCurrentTimersState.m
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 18/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GOTimersState.h"
#import "GOTimerStore.h"
#import "GOTimer.h"

@implementation GOTimersState

+ (instancetype)currentState {
    static GOTimersState *currentState = nil;
    
    // Do I need to create a timersState?
    if (!currentState) {
        currentState = [[self alloc] initPrivate];
    }
    
    return currentState;
}

// If a programmer calls init - let them know the error of there ways
- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[GOTimersState currentState]" userInfo:nil];
    return nil;
}

// Here is the real (secret) initialiser
- (instancetype)initPrivate {
    self = [super init];
    
    if (self) {
        _currentTimerIndex = 0;
        _timerOrderIndex = 0;
        _isActive = NO;
        _countdownRemaining = 0;
        _createdFirstTimer = NO;
        _shownAllCoachMarks = NO;
    }
    
    return self;
}


@end
