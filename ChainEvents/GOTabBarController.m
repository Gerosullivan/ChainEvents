//
//  GOTabBarController.m
//  ChainEvents
//
//  Created by Gerald O'Sullivan on 09/01/2015.
//  Copyright (c) 2015 Ger O'Sullivan. All rights reserved.
//

#import "GOTabBarController.h"

@interface GOTabBarController ()

@end

@implementation GOTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"Setup"]) {
        NSLog(@"setup selected");
        UINavigationController *nc = self.viewControllers[0];
        [nc popViewControllerAnimated:NO];
    }
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
