//
//  GOItem.h
//  ChainEvents
//
//  Created by Ger O'Sullivan on 02/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOTimer : NSObject

@property (nonatomic, copy) NSString *timerName;
@property (nonatomic) NSTimeInterval timerDuration;
@property (nonatomic) NSInteger timerRepeat;
@property (nonatomic) NSArray *timerRepeatOptions;
@property (nonatomic) NSTimeInterval currentTimeLeft;

@end
