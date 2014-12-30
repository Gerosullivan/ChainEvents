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
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[GOTimerStore sharedStore]" userInfo:nil];
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
    [self populateTimerInstancesList];
    
    return timer;
}

- (void)removeTimer:(GOTimer *)timer {
    [self.privateTimers removeObjectIdenticalTo:timer];
    [self populateTimerInstancesList];
}

- (void)moveTimerAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    // Get pointer to object being moved so you can reinsert it
    GOTimer *timer = self.privateTimers[fromIndex];
    
    [self.privateTimers removeObjectAtIndex:fromIndex];
    [self.privateTimers insertObject:timer atIndex:toIndex];
    [self populateTimerInstancesList];
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

- (void)populateTimerInstancesList {
    self.allTimerInstances = [[NSMutableArray alloc] init];
    
    for (int x = 0 ; x < [[[GOTimerStore sharedStore] allTimers] count]; x++) {
        NSArray *timerDetails = [[NSArray alloc] init];
        GOTimer *thisTimer = [[GOTimerStore sharedStore] allTimers][x];
        NSString *fullPrefix;
        NSInteger timerNumber = x + 1;
        
        for (int y = 0; y <= thisTimer.timerRepeat; y++) {
            if (thisTimer.timerRepeat > 0) {
                fullPrefix = [NSString stringWithFormat:@"%ld.%ld ",
                              (long)timerNumber,
                              (long)y + 1];
            } else {
                fullPrefix = [NSString stringWithFormat:@"%ld ", (long)timerNumber];
            }
            timerDetails = @[thisTimer, fullPrefix];
            [self.allTimerInstances addObject:timerDetails];
        }
    }
    //    NSLog(@"timersList: %@", self.allTimers);
}

- (NSUInteger)firstIndexOfTimerInInstancesList:(GOTimer *)timer {
    for (int x = 0; x < [self.allTimerInstances count]; x ++) {
        if (self.allTimerInstances[x][0] == timer){
            return x;
        }
    }
    return 0;
}





@end
