//
//  GOItemStore.m
//  ChainEvents
//
//  Created by Ger O'Sullivan on 02/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GOTimerStore.h"
#import "GOTimer.h"

@interface GOTimerStore ()

@property (nonatomic) NSMutableArray *privateTimers;

@end

@implementation GOTimerStore

+ (instancetype)sharedStore {
    static GOTimerStore *sharedStore = nil;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

// If a programmer calls init - let them know the error of there ways
- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[GOItemStore sharedStore]" userInfo:nil];
    return nil;
}

// Here is the real (secret) initialiser
- (instancetype)initPrivate {
    self = [super init];
    
    if (self) {
        _privateTimers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *) allTimers {
    return self.privateTimers;
}

- (GOTimer *)createTimer {
    GOTimer *timer = [[GOTimer alloc] init];
    
    [self.privateTimers addObject:timer];
    
    return timer;
}

- (void)removeTimer:(GOTimer *)timer {
    [self.privateTimers removeObjectIdenticalTo:timer];
}

- (void)moveTimerAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    // Get pointer to object being moved so you can reinsert it
    GOTimer *timer = self.privateTimers[fromIndex];
    
    [self.privateTimers removeObjectAtIndex:fromIndex];
    [self.privateTimers insertObject:timer atIndex:toIndex];
}

















@end