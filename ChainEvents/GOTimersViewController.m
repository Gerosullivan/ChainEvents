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

@implementation GOTimersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([GOTimersState currentState].isActive && [GOTimersState currentState].timerOrderIndex == indexPath.row) {
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
    if ([GOTimersState currentState].isActive && [GOTimersState currentState].timerOrderIndex == indexPath.row) {
        return NO;
    }
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([GOTimersState currentState].isActive == YES && [GOTimersState currentState].timerOrderIndex == indexPath.row) {
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
