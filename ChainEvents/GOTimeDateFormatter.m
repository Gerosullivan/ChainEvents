//
//  timeDateFormatter.m
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 20/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GOTimeDateFormatter.h"

@implementation GOTimeDateFormatter

- (NSString *)shortTime:(NSInteger)interval {
    
    NSMutableString *TimerDetail = [[NSMutableString alloc] init];
    NSInteger seconds = interval % 60;
    NSInteger minutes = (interval / 60) % 60;
    NSInteger hours = (interval / 3600);
    
    TimerDetail = [NSMutableString stringWithFormat:@"%02ldm", (long)minutes];
    if (seconds > 0) {
        NSString *secondsString = [NSString stringWithFormat:@" %02lds", seconds];
        [TimerDetail appendString:secondsString];
    }
    if (hours > 0) {
        NSString *hoursString = [NSString stringWithFormat:@"%02ldh ", hours];
        [TimerDetail insertString:hoursString atIndex:0];
    }
    return TimerDetail;
}

@end
