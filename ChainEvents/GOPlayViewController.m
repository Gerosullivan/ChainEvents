//
//  GOPlayViewController.m
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 13/12/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "GOPlayViewController.h"
#import "CircleLineButton.h"

@interface GOPlayViewController ()

@property (nonatomic) CircleLineButton *playButton;
@property (nonatomic) CircleLineButton *pauseButton;
@property (nonatomic) UILabel *statusLabel;

@end

@implementation GOPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.sectionHeaderHeight = 1.0;
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    
    // Create the round Play button
    
    self.playButton = [[CircleLineButton alloc] initWithFrame:CGRectMake(0, 20, buttonSize, buttonSize)];
    
    [self.playButton drawCircleButton:[UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:1]];
    
    [self.playButton setTitle:@"Start" forState:UIControlStateNormal];
    
    [footerButtons addSubview:self.playButton];
    
    // Create the round Pause button
    
    self.pauseButton = [[CircleLineButton alloc] initWithFrame:CGRectMake(110, 20, buttonSize, buttonSize)];
    [self.pauseButton drawCircleButton:[UIColor lightGrayColor]];
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [self.pauseButton setEnabled:NO];

    [footerButtons addSubview:self.pauseButton];
    
    // The status label
    
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, buttonSize +40, footerButtons.frame.size.width, 30)];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.text = @"3h 50m remaining. Finish at 12:34 PM.";
    self.statusLabel.textColor = [UIColor lightGrayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [footerButtons addSubview:self.statusLabel];
    
    NSDictionary *nameMap = @{@"playButton" : self.playButton,
                              @"pauseButton" : self.pauseButton,
                              @"statusLabel" : self.statusLabel};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-40-[playButton]-20-[pauseButton]-40-|"
                                      options:0
                                      metrics:nil
                                      views:nameMap];
    
    NSArray *verticalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-40-[playButton]-20-[statusLabel]-40-|"
                                      options:0
                                      metrics:nil
                                      views:nameMap];
    footerButtons.translatesAutoresizingMaskIntoConstraints = NO;
    footerButtons.contentMode = UIViewContentModeScaleAspectFit;
    
    [footerButtons addConstraints:horizontalConstraints];
    [footerButtons addConstraints:verticalConstraints];
    
    return footerButtons;
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
