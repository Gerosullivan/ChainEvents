//
//  AppDelegate.m
//  ChainEvents
//
//  Created by Ger O'Sullivan on 21/11/2014.
//  Copyright (c) 2014 Ger O'Sullivan. All rights reserved.
//

#import "AppDelegate.h"
#import "GOTimerStore.h"
#import "GOTimersState.h"
#import "GOPlayViewController.h"

@interface AppDelegate ()

// Alert elements
@property (nonatomic) UIAlertView *alertView;
@property (nonatomic, retain) AVAudioPlayer *soundPlayer;
@property (nonatomic) UITabBarController *tabBarController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"application didFinishLaunchingWithOptions");
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        //Launched cold by notification alarm event
        [GOTimerStore sharedStore];
        [self showEndTimerAlert];
    }
    
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");

    BOOL success = [[GOTimerStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the GOTimers");
    } else {
        NSLog(@"Could not save any of the GOTimers");
    }
    
    [[GOTimersState currentState] saveState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Alert View Actions
- (void)didPresentAlertView:(UIAlertView *)alertView {
    // Regardless of which tabbar we are on - go to the Play VC
    self.tabBarController.selectedIndex = 1;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.soundPlayer.playing)
        [self.soundPlayer stop];
    
    // Access the Play VC and call the next Timer via loadTimer
    UINavigationController *nc = self.tabBarController.viewControllers[self.tabBarController.selectedIndex];
    GOPlayViewController *pc = (GOPlayViewController *) nc.topViewController;
    [pc loadTimer:1];
    
}

- (void)showEndTimerAlert {
    self.alertView = nil;
    NSString *alertTitle;
    [[GOTimerStore sharedStore] populateTimerInstancesList];
    if ([GOTimersState currentState].currentTimerIndex +1 == [GOTimerStore sharedStore].allTimerInstances.count){
        // No more timers in the queue
        alertTitle = @"There are no more timers.";
    } else {
        alertTitle = @"Press OK to show next timer.";
    }
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Timer Finished" message:alertTitle delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [self.alertView show];
    
    
    // Only play the sound if the App is Active
    // Otherwise the notification alert will sound the alarm
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSString *soundFilePath =
        [[NSBundle mainBundle] pathForResource: @"alarm_beep"
                                        ofType: @"caf"];
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                               error: nil];
        
        self.soundPlayer = newPlayer;
        
        [self.soundPlayer prepareToPlay];
        [self.soundPlayer setDelegate: self];
        
        [self.soundPlayer play];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
}

@end
