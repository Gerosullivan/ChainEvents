//
//  GOItem.m
//  ChainEvents
//
//  Created by Ger O'Sullivan on 02/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GOTimer.h"

@implementation GOTimer

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _timerName = @"Ger test timer";
        _timerDuration = 10;
        _timerRepeat = 1;
        _timerRepeatOptions = @[@"Never", @"2 times", @"3 times", @"4 times", @"5 times", @"6 times", @"7 times", @"8 times", @"9 times", @"10 times", @"11 times", @"12 times"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.timerName forKey:@"timerName"];
    [aCoder encodeDouble:self.timerDuration forKey:@"timerDuration"];
    [aCoder encodeBool:self.timerRepeat forKey:@"timerRepeat:"];
    [aCoder encodeObject:self.timerRepeatOptions forKey:@"timerRepeatOptions"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _timerName = [aDecoder decodeObjectForKey:@"timerName"];
        _timerDuration = [aDecoder decodeDoubleForKey:@"timerDuration"];
        _timerRepeat = [aDecoder decodeBoolForKey:@"timerRepeat"];
        _timerRepeatOptions = [aDecoder decodeObjectForKey:@"timerRepeatOptions"];
    }
    return self;
}

@end
