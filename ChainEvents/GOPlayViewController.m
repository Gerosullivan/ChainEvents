//
//  GOPlayViewController.m
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 13/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GOPlayViewController.h"
#import "CircleLineButton.h"
#import "GOTimerStore.h"
#import "GOTimer.h"
#import "GOTimersState.h"

@interface GOPlayViewController ()

// Timer properties
@property (nonatomic) GOTimer *currentTimerObject;
@property (nonatomic, weak) NSTimer *repeatingTimer;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) NSTimeInterval countdownRemaining;
@property (nonatomic) NSTimeInterval countdownFrom;
@property (nonatomic) NSTimeInterval totalTimeRunning;

// Timer Labels
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerName;

// Table footer elements
@property (nonatomic) CircleLineButton *playButton;
@property (nonatomic) CircleLineButton *pauseButton;
@property (nonatomic) UILabel *statusLabel;

// Alert elements
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic, retain) AVAudioPlayer *soundPlayer;

@end

@implementation GOPlayViewController

@synthesize soundPlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.sectionHeaderHeight = 1.0;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[GOTimersState currentState] currentTimer] == nil) {
        GOTimer *firstTimer = [[GOTimerStore sharedStore] allTimers][0];
        [[GOTimersState currentState] newTimer:firstTimer];
        self.currentTimerObject = firstTimer;
        
        [self resetTimer];
        [self makeTimerName];
    } else {
        if ([GOTimersState currentState].isActive == NO) {
            [self resetTimer];
            [self makeTimerName];
        }
    }
    
    NSUInteger numberOfTimers = [[[GOTimerStore sharedStore] allTimers] count];
    NSUInteger currentTimerNumber =[GOTimersState currentState].currentTimerIndex +1;
    
    self.navigationItem.title = [NSString stringWithFormat:@"Timer %ld of %ld", currentTimerNumber, numberOfTimers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [GOTimersState currentState].countdownRemaining = self.countdownRemaining;
    
}

# pragma mark - Timer Methods

- (void) updateTimer {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    
    self.countdownRemaining = self.countdownFrom - timeInterval;
    
    
    self.timerLabel.text = [self makeTimerString];
    
    if (self.countdownRemaining <= 0) {
        [self timerFinished];
    }
}

- (void)stopTimer {
    NSLog(@"Stop timer");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

- (void)resetTimer {
    [self.playButton changeToPrimaryColor];
    [self.playButton setTitle:@"Start" forState:UIControlStateNormal];
    
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    self.isPaused = NO;
    self.pauseButton.alpha = 0.5;
    [self.pauseButton setEnabled:NO];
    
    
    self.countdownFrom = self.currentTimerObject.timerDuration;
    
    self.countdownRemaining = self.currentTimerObject.timerDuration;
    self.timerLabel.text = [self makeTimerString];
    
    [GOTimersState currentState].isActive = NO;
}

- (void)pauseTimer {
    NSLog(@"Pause timer");
    if (self.isPaused) {
        [self startTimer];
        [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        self.isPaused = NO;
    } else {
        [self stopTimer];
        [self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
        self.isPaused = YES;
        self.countdownFrom = self.countdownRemaining;
    }
}

- (void)startTimer {
    [self.playButton changeToSecondaryColor:[UIColor colorWithRed:1 green:0.15 blue:0 alpha:1]];
    [self.playButton setTitle:@"Reset" forState:UIControlStateNormal];
    
    [self.pauseButton setEnabled:YES];
    self.pauseButton.alpha = 1;
    self.isPaused = NO;
    
    // Kill any repeating scheduled timers
    if (self.repeatingTimer) {
        [self.repeatingTimer invalidate];
        self.repeatingTimer = nil;
    }
    
    self.startDate = [NSDate date];
    
    self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                     target:self
                                                   selector:@selector(updateTimer)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [GOTimersState currentState].isActive = YES;

    // Create Local Notification alerm to go off when timer finishes
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    alarm.alertBody = @"Timer finished";
    NSDate *fireDate = [NSDate dateWithTimeInterval:self.countdownRemaining sinceDate:self.startDate];
    alarm.fireDate = fireDate;
    alarm.soundName = @"alarm_beep.caf";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
}

- (NSString *)makeTimerString {
    NSInteger ti = (NSInteger)self.countdownRemaining;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    return [NSString stringWithFormat:@"%02ld:%02ld.%02ld", (long)hours, (long)minutes, (long)seconds];
}

- (void)makeTimerName {
    NSString *prefix;
    NSInteger index = [[GOTimersState currentState] currentTimerIndex] +1;
    if (self.currentTimerObject.timerRepeat > 0) {
        prefix = [NSString stringWithFormat:@"%ld.%ld ", (long)index, (long)self.currentTimerObject.timerRepeat +1];
    } else {
        prefix = [NSString stringWithFormat:@"%ld ", (long)index];
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:prefix];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [prefix length])];
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:self.currentTimerObject.timerName];
    [attString appendAttributedString:name];
    
    self.timerName.attributedText = attString;
    
    // Make the Next Timer label while we are at it
    
}

- (void)timerFinished {
    NSLog(@"Timer Finised");
    
    self.alertView = nil;
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Timer Finished" message:@"Next Timer ready" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [self.alertView show];
    
    [self stopTimer];
    [GOTimersState currentState].isActive = NO;
    
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource: @"alarm_beep"
                                    ofType: @"caf"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    
    self.soundPlayer = newPlayer;
    
    [soundPlayer prepareToPlay];
    [soundPlayer setDelegate: self];
}

# pragma mark - Table Methods

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // Minimise the section header hack
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 540, 10)];
//    footer.backgroundColor = [UIColor clearColor];
//    
//    UILabel *lbl = [[UILabel alloc]initWithFrame:footer.frame];
//    lbl.backgroundColor = [UIColor clearColor];
//    lbl.text = @"Your Text";
//    lbl.textAlignment = NSTextAlignmentCenter;
//    [footer addSubview:lbl];
    
    int buttonSize = 90;
    
    UIView *footerButtons = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 200)];
    footerButtons.backgroundColor = [UIColor clearColor];
    
//    footerButtons.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create the round Play button
    
    self.playButton = [[CircleLineButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
    [self.playButton drawCircleButton:[UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:1]];
    [self.playButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [footerButtons addSubview:self.playButton];
    
    // Create the round Pause button
    
    self.pauseButton = [[CircleLineButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
    [self.pauseButton drawCircleButton:[UIColor darkGrayColor]];
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [self.pauseButton setEnabled:NO];
    self.pauseButton.alpha = 0.5;
    [self.pauseButton addTarget:self action:@selector(pauseTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [footerButtons addSubview:self.pauseButton];
    
    // The status label
    
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, footerButtons.frame.size.width, 30)];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.text = @"3h 50m remaining. Finish at 12:34 PM.";
    self.statusLabel.textColor = [UIColor lightGrayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [footerButtons addSubview:self.statusLabel];
    
    // Layout Constraints
    
    NSDictionary *nameMap = @{@"playButton" : self.playButton,
                              @"pauseButton" : self.pauseButton,
                              @"statusLabel" : self.statusLabel};
    
    NSLayoutConstraint *horizontalConstraint1 = [NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footerButtons attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0];
    
    NSLayoutConstraint *horizontalConstraint2 = [NSLayoutConstraint constraintWithItem:self.pauseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footerButtons attribute:NSLayoutAttributeCenterX multiplier:1.5 constant:0];
    
    
    NSArray *horizontalConstraint3 = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-40-[statusLabel]-40-|"
                                      options:0
                                      metrics:nil
                                      views:nameMap];
    
    NSArray *verticalConstraint1 = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-20-[playButton]-15-[statusLabel]"
                                    options:0
                                    metrics:nil
                                    views:nameMap];
    
    NSArray *verticalConstraint2 = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-20-[pauseButton]"
                                    options:0
                                    metrics:nil
                                    views:nameMap];
    
    footerButtons.contentMode = UIViewContentModeScaleAspectFit;
    
    [footerButtons addConstraint:horizontalConstraint1];
    [footerButtons addConstraint:horizontalConstraint2];
    [footerButtons addConstraints:horizontalConstraint3];
    [footerButtons addConstraints:verticalConstraint1];
    [footerButtons addConstraints:verticalConstraint2];
    
    return footerButtons;
}

#pragma mark - Button Actions

-(IBAction)playTouched:(id)sender {
    if ([self.playButton.titleLabel.text isEqual: @"Start"]) {
        NSLog(@"Start touched");
//        [self resetTimer];
        [self startTimer];
    } else {
        NSLog(@"Reset touched");
        [self stopTimer];
        [self resetTimer];
    }

}

-(IBAction)pauseTouched:(id)sender {
    [self pauseTimer];
}

#pragma mark - Alert View Actions
- (void)didPresentAlertView:(UIAlertView *)alertView {
    [self.soundPlayer play];
    self.tabBarController.selectedIndex = 1;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.soundPlayer stop];
}

@end
