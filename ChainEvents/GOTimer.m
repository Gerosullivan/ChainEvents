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
        _timerName = @"My New Timer";
        _timerDuration = @12;
        _timerRepeat = 0;
        _timerRepeatOptions = @[@"Never", @"2 Times", @"3 Times", @"4 Times", @"5 Times", @"6 Times", @"7 Times", @"8 Times", @"9 Times", @"10 Times", @"11 Times", @"12 Times", @"13 Times"];
    }
    return self;
}

@end
