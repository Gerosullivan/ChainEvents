//
//  timeDateFormatter.h
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 20/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOTimeDateFormatter : NSDate

- (NSString *)shortTime:(NSInteger)interval;
- (NSString *)clockTime:(NSInteger)interval;

@end
