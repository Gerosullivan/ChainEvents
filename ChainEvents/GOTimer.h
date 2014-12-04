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
@property (nonatomic) int timerDuration;
@property (nonatomic) BOOL timerRepeat;

@end
