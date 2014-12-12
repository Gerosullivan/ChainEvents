//
//  GODetailViewController.m
//  ChainEvents
//
//  Created by Ger O'Sullivan on 09/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GODetailViewController.h"
#import "GORepeatViewController.h"
#import "GOTimerStore.h"

@interface GODetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *repeatCell;

@end

@implementation GODetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    if (self.existingTimer) {
        self.navigationItem.title = @"Edit Timer";
    } else {
        self.navigationItem.title = @"New Timer";
    }
    
    self.nameField.text = self.timer.timerName;
    
    self.durationPicker.delegate = self;
    self.durationPicker.dataSource = self;
    
    NSInteger ti = (NSInteger)self.timer.timerDuration;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    [self.durationPicker selectRow:hours inComponent:0 animated:NO];
    [self.durationPicker selectRow:minutes inComponent:1 animated:NO];
    [self.durationPicker selectRow:seconds inComponent:2 animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Remove the 'Done' button if this is an existing timer
    if (self.existingTimer) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.repeatCell.detailTextLabel.text = self.timer.timerRepeatOptions[self.timer.timerRepeat];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer.timerDuration == 0) {
        [[GOTimerStore sharedStore] removeTimer:self.timer];
    } else {
        self.timer.timerName = self.nameField.text;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)done:(id)sender {
    NSLog(@"pvc: %@", self.presentedViewController);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller
    if ([segue.identifier isEqualToString:@"repeatView"]) {
        GORepeatViewController *rvc = segue.destinationViewController;
        rvc.timer = self.timer;
    }
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    }
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width/3 - 35, 30)];
    columnView.text = [NSString stringWithFormat:@"%lu", row];
    columnView.textAlignment = NSTextAlignmentLeft;
    
    return columnView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.timer.timerDuration = (NSTimeInterval)self.calculateTimeFromPicker;
    
}

-(NSInteger)calculateTimeFromPicker
{
    
    NSString *hoursStr = [NSString stringWithFormat:@"%ld",(long)[self.durationPicker selectedRowInComponent:0]];
    
    NSString *minsStr = [NSString stringWithFormat:@"%ld",(long)[self.durationPicker selectedRowInComponent:1]];
    
    NSString *secsStr = [NSString stringWithFormat:@"%ld",(long)[self.durationPicker selectedRowInComponent:2]];
    
    int hoursInt = [hoursStr intValue];
    int minsInt = [minsStr intValue];
    int secsInt = [secsStr intValue];
    
    
    int interval = secsInt + (minsInt*60) + (hoursInt*3600);
    
    NSLog(@"hours: %d ... mins: %d .... sec: %d .... interval: %d", hoursInt, minsInt, secsInt, interval);
    
    return interval;
    
}

@end
