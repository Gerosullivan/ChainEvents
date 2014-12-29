//
//  GOItemStore.h
//  ChainEvents
//
//  Created by Ger O'Sullivan on 02/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GOTimer;

@interface GOTimerStore : NSObject

@property (nonatomic, readonly) NSArray *allTimers;
@property (nonatomic) NSMutableArray *allTimerInstances;

+ (instancetype)sharedStore;

- (GOTimer *)createTimer;
- (void)removeTimer:(GOTimer *)timer;
- (void)moveTimerAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)populateTimerInstancesList;

- (BOOL)saveChanges;

@end
