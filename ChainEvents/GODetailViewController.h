//
//  GODetailViewController.h
//  ChainEvents
//
//  Created by Ger O'Sullivan on 04/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOTimer.h"

@interface GODetailViewController : UIViewController

@property (nonatomic) BOOL existingTimer;
@property (nonatomic) GOTimer *timer;

@end
