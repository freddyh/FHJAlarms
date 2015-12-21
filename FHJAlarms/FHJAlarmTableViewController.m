//
//  FHJAlarmTableViewController.m
//  FHJAlarms
//
//  Created by fredhedz on 3/28/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJAlarmTableViewController.h"
#import "FHJALarmTableViewCell.h"
#import "FHJAlarmDetailViewController.h"
#import "FHJAlarmManager.h"
#import "FHJAlarm.h"

@interface FHJAlarmTableViewController ()

@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation FHJAlarmTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *navItem = self.navigationItem;
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [titleView setText:@"Weakling"];
//    [titleView setTextColor:[UIColor whiteColor]];
    
    navItem.titleView = titleView;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlarm:)];
    navItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UINib *nib = [UINib nibWithNibName:@"FHJAlarmTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"AlarmCell"];
    
    [self.tableView setAllowsSelection:NO];
    [self.tableView setAllowsSelectionDuringEditing:YES];
//    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger dataCount = [[[FHJAlarmManager sharedInstance] allAlarms] count];
    if (dataCount > 0) {
        [self.tableView setBackgroundView:nil];
    }
    
    [self.tableView reloadData];
}

- (void)addAlarm:(id)sender
{
    //present alarm detail controller
    FHJAlarmDetailViewController *alarmDetailViewController = [FHJAlarmDetailViewController new];
    alarmDetailViewController.alarm = nil;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:alarmDetailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:navController animated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[FHJAlarmManager sharedInstance] allAlarms] count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSInteger alarmCount = [[[FHJAlarmManager sharedInstance] allAlarms] count];
    return  alarmCount == 0 ? @"You have no alarms scheduled" : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHJALarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell" forIndexPath:indexPath];
    if (cell == nil) {
        
    }
    
    NSArray *alarms = [[FHJAlarmManager sharedInstance] allAlarms];
    NSUInteger row = indexPath.row;
    FHJAlarm *fhjAalrm = [alarms objectAtIndex:row];
    
//    NSString *alarmNameWithComma = [NSString stringWithFormat:@"%@ ,", fhjAalrm.alarmName];
    cell.nameLabel.attributedText = [fhjAalrm alarmDetails];
//    cell.daysLabel.text = [[fhjAalrm daysString] isEqualToString:@"Never"] ? nil :[fhjAalrm daysString];
    cell.timeLabel.attributedText = [fhjAalrm timeString];
    cell.masterSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:fhjAalrm.alarmKey];
    cell.alarmKey = fhjAalrm.alarmKey;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundColor = ((FHJALarmTableViewCell *)cell).masterSwitch.on ? nil : [UIColor lightGrayColor];
}


- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FHJALarmTableViewCell *cell = (FHJALarmTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *alarms = [[FHJAlarmManager sharedInstance] allAlarms];
    NSUInteger row = indexPath.row;
    
    FHJAlarmDetailViewController *detailController = [FHJAlarmDetailViewController new];
    detailController.alarm = alarms[row];
    
    [self.navigationController pushViewController:detailController animated:YES];
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *alarms = [[FHJAlarmManager sharedInstance] allAlarms];
        NSUInteger row = [indexPath row];
        FHJAlarm *alarm = alarms[row];
        [[FHJAlarmManager sharedInstance] removeAlarm:alarm];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)scheduleNotifications
{
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
