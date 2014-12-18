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
        NSString *path = [self timerArchivePath];
        _privateTimers = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!_privateTimers) {
            _privateTimers = [[NSMutableArray alloc] init];
        }
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

- (GOTimer *)currentTimer {
    NSUInteger currentTimerIndex = [self.privateTimers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([(GOTimer*)obj countdownRemaining] > 0 || [(GOTimer*)obj currentRepeat] > 0) {
            *stop = YES;
            return idx;
        }
        return 0;
    }];
    if (currentTimerIndex != NSNotFound){
        NSLog(@"timerIndex:%lu", (unsigned long)currentTimerIndex);
        return self.privateTimers[currentTimerIndex];
    } else {
        NSLog(@"no timers are current");
        return self.privateTimers[0];
    }
    
}

- (NSString *)timerArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"timers.archive"];
}

- (BOOL)saveChanges {
    NSString *path = [self timerArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateTimers toFile:path];
}













@end
