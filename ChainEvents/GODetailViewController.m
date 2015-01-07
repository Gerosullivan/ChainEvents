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
#import "GOTimersState.h"

@interface GODetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *repeatCell;

//@property (nonatomic) UIButton *playButton;

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
    self.nameField.delegate = self;
    
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
//        self.playButton.hidden = NO;
//        NSLog(@"Dont hide play");
    }
    
    self.repeatCell.detailTextLabel.text = self.timer.timerRepeatOptions[self.timer.timerRepeat];

    int o = 40;
    int w = self.view.frame.size.width/3 - o;

    UILabel *hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(o, 66, w, 30)];
    hoursLabel.text = @"hours";
    hoursLabel.textAlignment = NSTextAlignmentLeft;
    hoursLabel.font = [UIFont boldSystemFontOfSize:18];

    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(w+(o*2), 66, w, 30)];
    minsLabel.text = @"mins";
    minsLabel.textAlignment = NSTextAlignmentLeft;
    minsLabel.font = [UIFont boldSystemFontOfSize:18];

    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake((w*2)+(o*3), 66, w, 30)];
    secsLabel.text = @"sec";
    secsLabel.textAlignment = NSTextAlignmentLeft;
    secsLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [self.durationPicker addSubview:hoursLabel];
    [self.durationPicker addSubview:minsLabel];
    [self.durationPicker addSubview:secsLabel];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer.timerDuration == 0) {
        [[GOTimerStore sharedStore] removeTimer:self.timer];
    } else {
        self.timer.timerName = self.nameField.text;
        
        if (![GOTimersState currentState].createdFirstTimer)
            [GOTimersState currentState].createdFirstTimer = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerButton;
//    
//    if (section == 1) {
//        footerButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 100)];
//        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
//        [self.playButton setTitle: @"Start Timer" forState:UIControlStateNormal];
//        [self.playButton setTitleColor:[UIColor colorWithRed:0.01 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
//        [self.playButton addTarget:self action:@selector(playTouched:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [footerButton addSubview:self.playButton];
//        
//        if (!self.existingTimer)
//            self.playButton.hidden = YES;
//        
//    } else {
//        footerButton = nil;
//    }
//
//    return footerButton;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 400;
    }
    return 1;
}


#pragma mark - Navigation

- (IBAction)done:(id)sender {
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
    columnView.text = [NSString stringWithFormat:@"%lu", (long)row];
    columnView.textAlignment = NSTextAlignmentLeft;
    
    return columnView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.timer.timerDuration = (NSTimeInterval)self.calculateTimeFromPicker;
}

-(NSInteger)calculateTimeFromPicker {
    
    NSString *hoursStr = [NSString stringWithFormat:@"%ld",(long)[self.durationPicker selectedRowInComponent:0]];
    NSString *minsStr = [NSString stringWithFormat:@"%ld",(long)[self.durationPicker selectedRowInComponent:1]];
    NSString *secsStr = [NSString stringWithFormat:@"%ld",(long)[self.durationPicker selectedRowInComponent:2]];
    
    int hoursInt = [hoursStr intValue];
    int minsInt = [minsStr intValue];
    int secsInt = [secsStr intValue];
    
    
    int interval = secsInt + (minsInt*60) + (hoursInt*3600);
    
//    NSLog(@"hours: %d ... mins: %d .... sec: %d .... interval: %d", hoursInt, minsInt, secsInt, interval);
    
//    if (hoursInt + minsInt + secsInt == 0) {
//        self.playButton.hidden = YES;
//    } else {
//        self.playButton.hidden = NO;
//    }
    
    return interval;
    
}

- (IBAction)playTouched:(id)sender {
    NSLog(@"Play touched!");
    [[GOTimerStore sharedStore] populateTimerInstancesList];
    NSUInteger timerInstanceIndex = [[GOTimerStore sharedStore] firstIndexOfTimerInInstancesList:self.timer];
    
    NSLog(@"timerInstanceIndex, %ld", timerInstanceIndex);
    [GOTimersState currentState].currentTimerIndex = timerInstanceIndex;
    NSUInteger timerIndex = [[[GOTimerStore sharedStore] allTimers] indexOfObjectIdenticalTo:self.timer];
    [GOTimersState currentState].timerOrderIndex = timerIndex;
    self.tabBarController.selectedIndex = 1;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"Return pressed");
    [textField resignFirstResponder];
    return YES;
}

@end
