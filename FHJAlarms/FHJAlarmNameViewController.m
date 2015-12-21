//
//  FHJAlarmNameViewController.m
//  FHJAlarms
//
//  Created by fredhedz on 3/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJAlarmNameViewController.h"

@interface FHJAlarmNameViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation FHJAlarmNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *alarmName = _alarm.alarmName;
    if (![alarmName isEqualToString:@"No Name"]) {
        [_nameField setText:alarmName];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_nameField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _alarm.alarmName = _nameField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
    
}

@end
