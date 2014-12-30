//
//  GODetailViewController.h
//  ChainEvents
//
//  Created by Ger O'Sullivan on 09/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOTimer.h"

@interface GODetailViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic) BOOL existingTimer;

@property (nonatomic) GOTimer *timer;

@end
