//
//  AppDelegate.m
//  FHJAlarms
//
//  Created by fredhedz on 3/28/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "AppDelegate.h"
#import "FHJAlarmTableViewController.h"
#import "FHJWallpaperViewController.h"
#import "FHJLoginViewController.h"

#import "FHJAlarmManager.h"
#import "FHJAlarm.h"
#import "QuotesManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController *masterNav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self presentAlarmController];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:0 blue:.4 alpha:1.0]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window setBackgroundColor:[UIColor clearColor]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)presentAlarmController
{
    FHJAlarmTableViewController *alarmController = [FHJAlarmTableViewController new];
    _masterNav = [[UINavigationController alloc] initWithRootViewController:alarmController];
    self.window.rootViewController = _masterNav;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if ([[FHJAlarmManager sharedInstance] saveChanges]) {
        NSLog(@"Saved all alarms");
    } else {
        NSLog(@"Could not save alarms");
    }

    NSInteger alarmCount = [[[FHJAlarmManager sharedInstance] allActiveAlarms] count];
    if (alarmCount) {
        for (FHJAlarm *fhjAlarm in [[FHJAlarmManager sharedInstance] allActiveAlarms]) {
            for (NSDate *date in [fhjAlarm allFireDates]) {
                UILocalNotification *localNotification = [UILocalNotification new];
                NSString *quote = [[QuotesManager sharedInstance] quoteForFocus:fhjAlarm.focus];
                NSString *alerTitle = fhjAlarm.alarmName;
                localNotification.fireDate = date;
                localNotification.alertBody = quote;
                localNotification.alertTitle = alerTitle;
                //localNotification.repeatCalendar = [NSCalendar currentCalendar];
                //localNotification.repeatInterval = NSCalendarUnitWeekdayOrdinal;
                NSDictionary *alarmInfo = @{ @"alarmKey" : fhjAlarm.alarmKey };
                localNotification.userInfo = alarmInfo;
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }

        }
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSUInteger notifCount = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    if (notifCount > 0) {
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSLog(@"Cancelled all notifications");
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Received local notification");
    FHJWallpaperViewController *wallpaperController = [FHJWallpaperViewController new];
    wallpaperController.quote = notification.alertBody;
    wallpaperController.wallpaperTitle = notification.alertTitle;
    wallpaperController.imageKey = [notification.userInfo objectForKey:@"alarmKey"];
    [_masterNav pushViewController:wallpaperController animated:YES];
}

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
}

@end
