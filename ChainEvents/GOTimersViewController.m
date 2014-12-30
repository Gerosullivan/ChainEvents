//
//  GOSItemsViewController.m
//  ChainEvents
//
//  Created by Ger O'Sullivan on 02/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GOTimersViewController.h"
#import "GOTimerStore.h"
#import "GOTimer.h"
#import "GODetailViewController.h"
#import "GOTimersState.h"
#import "GOTimeDateFormatter.h"

@interface GOTimersViewController ()

@property (nonatomic) UIView *coachMark_add;
@property (nonatomic) UIView *coachMark_start;

@end

@implementation GOTimersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
    
    // Create the CoachMark View for the Add button
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.coachMark_add = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight)];
    self.coachMark_add.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIImage *coachImage = [UIImage imageNamed:@"coachMark"];
    UIImageView *coachImageView = [[UIImageView alloc] initWithImage:coachImage];
    [self.coachMark_add addSubview:coachImageView];
    coachImageView.frame = CGRectMake(screenWidth - coachImage.size.width - 26, 4, coachImage.size.width, coachImage.size.height);
    [self.tabBarController.view addSubview:self.coachMark_add];
    self.coachMark_add.hidden = YES;
    
    // Create the second Coach Mark for the Play button
    UIImage *coachImage2 = [UIImage imageNamed:@"coachMark2"];
    UIImageView *coachImageView2 = [[UIImageView alloc] initWithImage:coachImage2];
    self.coachMark_start = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - coachImage2.size.width, screenHeight - coachImage2.size.height - 50, coachImage2.size.width, coachImage2.size.height)];
    [self.coachMark_start addSubview:coachImageView2];
    [self.view addSubview:self.coachMark_start];
    self.coachMark_start.hidden = YES;
    
    // On App start, check to see if there was a previous timer running
    if ([GOTimersState currentState].currentTimerIndex > 0) {
        self.tabBarController.selectedIndex = 1;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    if ([[[GOTimerStore sharedStore] allTimers] count] == 0) {
        // No timers - show coach mark
        self.coachMark_add.hidden = NO;
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        // Test to see if the fist timer has been created
        // And we have not shown the Play CoachMark
        if ([GOTimersState currentState].createdFirstTimer && ![GOTimersState currentState].shownAllCoachMarks){
            self.coachMark_start.hidden = NO;
            // the coachmark is initiated at the finished position
            CGPoint endPos = self.coachMark_start.center;
            CGPoint startPos = CGPointMake(endPos.x, endPos.y+self.coachMark_start.frame.size.height);
            self.coachMark_start.center = startPos;
            [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.coachMark_start.center = endPos;
            } completion:nil];
            [GOTimersState currentState].shownAllCoachMarks = YES;
        } else {
            self.coachMark_start.hidden = YES;
        }
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        self.coachMark_add.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.coachMark_start.hidden = YES;
}

#pragma mark - Table delegate

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[GOTimerStore sharedStore] allTimers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *orderLabel, *nameLabel, *detailLabel;
    
    orderLabel = (UILabel *)[cell viewWithTag:1];
    orderLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    NSArray *timers = [[GOTimerStore sharedStore] allTimers];
    GOTimer *timer = timers[indexPath.row];
    
    nameLabel = (UILabel *)[cell viewWithTag:2];
    nameLabel.text = timer.timerName;
    
    GOTimeDateFormatter *formatter = [[GOTimeDateFormatter alloc] init];
    NSString *timeHMS = [formatter shortTime:timer.timerDuration];
    
    NSMutableString *TimerDetail = [[NSMutableString alloc] initWithString:timeHMS];
    
    if (timer.timerRepeat != 0) {
        NSString *repeatText = [NSString stringWithFormat:@" - Repeat %@", timer.timerRepeatOptions[timer.timerRepeat]];
        [TimerDetail appendString:repeatText];
    }
    
    detailLabel = (UILabel *)[cell viewWithTag:3];
    detailLabel.text = TimerDetail;
    
//    NSLog(@"timerIndex %ld, row %ld", (long)[GOTimersState currentState].timerOrderIndex , (long)indexPath.row);
    if ([GOTimersState currentState].isActive && indexPath.row <= [GOTimersState currentState].timerOrderIndex) {
        cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *nameLabel, *detailLabel;
    
    nameLabel = (UILabel *)[cell viewWithTag:2];
    detailLabel = (UILabel *)[cell viewWithTag:3];
    
    if ([nameLabel.text isEqual: @""]) {
        detailLabel.frame = CGRectMake(36, 22, detailLabel.frame.size.width, detailLabel.frame.size.height);
    }
    
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if ([GOTimersState currentState].isActive && indexPath.row <= [GOTimersState currentState].timerOrderIndex) {
        return NO;
    }
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([GOTimersState currentState].isActive == YES && indexPath.row <= [GOTimersState currentState].timerOrderIndex) {
        return nil;
    }
    return indexPath;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // If the table view is asking to commit a delete command
        NSArray *timers = [[GOTimerStore sharedStore] allTimers];
        GOTimer *timer = timers[indexPath.row];
        [[GOTimerStore sharedStore] removeTimer:timer];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    [[GOTimerStore sharedStore] moveTimerAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString: @"newTimer"]) {
        GOTimer *timer = [[GOTimerStore sharedStore] createTimer];
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        GODetailViewController *dvc = (GODetailViewController *)[nc topViewController];
        dvc.timer = timer;
    } else if ([segue.identifier isEqualToString:@"existingTimer"]) {
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        NSArray *ts = [[GOTimerStore sharedStore] allTimers];
        GOTimer *timer = ts[ip.row];
        
        // Set the timer pointer of the destination view controlller and set existing to true
        GODetailViewController *dvc = segue.destinationViewController;
        dvc.timer = timer;
        dvc.existingTimer = YES;
        
    }
}


- (IBAction)addNewTimer:(id)sender {
    // Create a new GOTimer and add it to the store
//    GOTimer *newTimer = [[GOTimerStore sharedStore] createTimer];
    
    // Figue out where that item is in the array
//    NSInteger *lastRow = [[[GOTimerStore sharedStore] allTimers] indexOfObject:newTimer];
    
}

@end
