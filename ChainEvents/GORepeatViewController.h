//
//  GORepeatViewController.h
//  ChainEvents
//
//  Created by Ger O'Sullivan on 09/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOTimer.h"

@interface GORepeatViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) GOTimer *timer;

@end
