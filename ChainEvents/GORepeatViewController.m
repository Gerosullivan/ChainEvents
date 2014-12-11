//
//  GORepeatViewController.m
//  ChainEvents
//
//  Created by Ger O'Sullivan on 09/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GORepeatViewController.h"

@interface GORepeatViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *repeatPicker;

@end

@implementation GORepeatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.repeatPicker.dataSource = self;
    self.repeatPicker.delegate = self;
    
    [self.repeatPicker selectRow:self.timer.timerRepeat inComponent:0 animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Repeat";
    
    NSLog(@"tro = %ld", (long)self.timer.timerRepeat);
    
    [self.repeatPicker selectRow:0 inComponent:0 animated:NO];
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.timer.timerRepeatOptions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.timer.timerRepeatOptions[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.timer.timerRepeat = row;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
