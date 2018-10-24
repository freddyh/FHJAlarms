//
//  FHJLoginViewController.m
//  FHJAlarms
//
//  Created by fredhedz on 4/7/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FHJLoginViewController.h"
#import "FHJAlarmTableViewController.h"

@interface FHJLoginViewController ()<FBSDKLoginButtonDelegate>
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@end

@implementation FHJLoginViewController

- (IBAction)continueButton:(id)sender {
    
    NSUUID *deviceID = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceIdString = [deviceID UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:deviceIdString forKey:@"WeaklingDefaultUser"];
    [self presentAlarmController];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        //present the alarm table
        [self presentAlarmController];
    }
    
    NSString *deviceKey = @"WeaklingDefaultUser";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:deviceKey]) {
        [self presentAlarmController];
        return;
    }
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;

    CGRect fbRect = _continueButton.frame;
    fbRect.origin.y -= 60;

    [loginButton setFrame:fbRect];
    [self.view addSubview:loginButton];
    
}

- (void)presentAlarmController
{
    FHJAlarmTableViewController *alarmController = [FHJAlarmTableViewController new];
    
    UINavigationController *masterNav = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [masterNav pushViewController:alarmController animated:YES];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if (!error) {
        [self presentAlarmController];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

@end
