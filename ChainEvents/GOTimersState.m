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

// If another programmer calls init - let them know the error of there ways
- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[GOTimersState currentState]" userInfo:nil];
    return nil;
}

// Here is the real (secret) initialiser
- (instancetype)initPrivate {
    self = [super init];
    
    if (self) {
        
        NSString *pListPath = [self timersStatePath];
        
        // read property list into memory as an NSData object
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:pListPath];
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        // convert static property list into dictionary object
        NSDictionary *dict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
        if (!dict) {
            // Or property list not created
            NSLog(@"Error reading plist, or not created: %@, format: %lu", errorDesc, format);
            // assign values
            _currentTimerIndex = 0;
            _timerOrderIndex = 0;
            _createdFirstTimer = NO;
            _shownAllCoachMarks = NO;
        } else {
            NSLog(@"PList retrieved: %@", dict);
            // assign values
            _currentTimerIndex = (NSInteger)[[dict objectForKey:@"currentTimerIndex"] integerValue];
            _timerOrderIndex = (NSInteger)[[dict objectForKey:@"timerOrderIndex"] integerValue];
            _createdFirstTimer = [[dict objectForKey:@"createdFirstTimer"] boolValue];
            _shownAllCoachMarks = [[dict objectForKey:@"shownAllCoachMarks"] boolValue];
        }
        
        // Non-saved properties
        _countdownRemaining = 0;
        _isActive = NO;
    }
    
    return self;
}


- (void)saveState {
    
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    // add elements to data file and write data to file
    [plistDict setObject:[NSNumber numberWithInteger:self.currentTimerIndex] forKey:@"currentTimerIndex"];
    [plistDict setObject:[NSNumber numberWithInteger:self.timerOrderIndex] forKey:@"timerOrderIndex"];
    [plistDict setObject:[NSNumber numberWithBool:self.createdFirstTimer] forKey:@"createdFirstTimer"];
    [plistDict setObject:[NSNumber numberWithBool:self.shownAllCoachMarks] forKey:@"shownAllCoachMarks"];

    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    NSString *pListPath = [self timersStatePath];
    
    // check is plistData exists
    if(plistData) {
        // write plistData to our Data.plist file
        NSLog(@"Created pListData successfully");
        BOOL fileWrite = [plistData writeToFile:pListPath atomically:YES];
        if (fileWrite) {
            NSLog(@"Saved pListData successfully");
        } else {
            NSLog(@"Didn't save the pListData!");
        }
    } else {
        NSLog(@"Error in saveData: %@", error);
    }
    
    
}

- (NSString *)timersStatePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"GOTimersState.plist"];
}



@end
