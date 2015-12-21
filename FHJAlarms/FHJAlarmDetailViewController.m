//
//  FHJAlarmDetailViewController.m
//  FHJAlarms
//
//  Created by fredhedz on 3/28/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJAlarmDetailViewController.h"
#import "FHJDaysTableViewController.h"
#import "FHJAlarmNameViewController.h"
#import "FHJFocusTableViewController.h"
#import "FHJAlarmManager.h"
#import "BNRImageStore.h"

@interface FHJAlarmDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UITableView *alarmOptionsTableview;
@property (strong, nonatomic) NSArray *alarmOptionsData;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSString *alertBody;

@end

@implementation FHJAlarmDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *navItem = self.navigationItem;
    
    if (_alarm == nil) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAlarm:)];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        
        navItem.rightBarButtonItem = rightButton;
        navItem.leftBarButtonItem = leftButton;

        _timePicker.date = [NSDate dateWithTimeIntervalSinceNow:60];
        _alarm = [[FHJAlarmManager sharedInstance] createAlarm];
        _alarm.fireTime = [_timePicker.date copy];
        
    } else {
        NSDate *date = _alarm.fireTime;
        _timePicker.date = date;
    }
    
    _alarmOptionsData = @[@"Repeat", @"Name", @"Focus"];
    [_timePicker setBackgroundColor:[UIColor whiteColor]];
    
    [_alarmOptionsTableview setEstimatedRowHeight:40];
    [_alarmOptionsTableview setRowHeight:UITableViewAutomaticDimension];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitleView];
    [_alarmOptionsTableview reloadData];
}

- (void)setTitleView
{
    UINavigationItem *navItem = self.navigationItem;
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [titleView setText:_alarm.alarmName];
    [titleView setTextColor:[UIColor whiteColor]];
    
    navItem.titleView = titleView;
}


- (void)viewWillDisappear:(BOOL)animated
{
    _alarm.fireTime = [_timePicker.date copy];
}

- (void)saveAlarm:(id)sender
{
    NSInteger focusCount = [_alarm.focus count];
    
    if (focusCount > 0) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        return;
    } else {
        if ([_alarm.focus count] == 0) {
            _alertTitle = @"Focus";
            _alertBody = @"You must select a focus";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_alertTitle message:_alertBody delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void)cancel:(id)sender {
    [[FHJAlarmManager sharedInstance] removeAlarm:_alarm];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _alarmOptionsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FHJAlarmOptionsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"FHJAlarmOptionsCell"];
    }
    
    NSUInteger row = indexPath.row;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *detailString = [NSString new];
    switch (row) {
        case 0:
            detailString = _alarm.daysString;
            break;
            
        case 1:
            detailString = _alarm.alarmName;
            break;
            
        case 2:
            detailString = _alarm.focusDescription;
            break;
        default:
            break;
    }

    cell.textLabel.text = _alarmOptionsData[row];
    cell.detailTextLabel.text = detailString;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            if ([cell.textLabel.text  isEqual: @"Repeat"]) {
                FHJDaysTableViewController *daysController = [FHJDaysTableViewController new];
                daysController.alarm = _alarm;
                [self.navigationController pushViewController:daysController animated:YES];
            }
            break;
        case 1:
            if ([cell.textLabel.text  isEqual: @"Name"]) {
                FHJAlarmNameViewController *nameController = [FHJAlarmNameViewController new];
                nameController.alarm = _alarm;
                [self.navigationController pushViewController:nameController animated:YES];
            }
            break;
        case 2:
            if ([cell.textLabel.text  isEqual: @"Focus"]) {
                FHJFocusTableViewController *focusController = [FHJFocusTableViewController new];
                focusController.alarm = _alarm;
                [self.navigationController pushViewController:focusController animated:YES];
            }
            break;
/*
        case 3:
            if ([cell.textLabel.text  isEqual: @"Wallpaper"]) {
                UIImagePickerController *imagePicker = [UIImagePickerController new];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
                
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:NULL];
            }
            break;
 */
        default:
            break;
    }

}

#pragma mark - Image Picker Delegate
/*
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *key = _alarm.alarmKey;
    
    if (key) {
        [[BNRImageStore sharedStore] deleteImageForKey:key];
    }
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [[BNRImageStore sharedStore] setImage:image forKey:key];
    [_alarm setThumbnailWithImage:image];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
 */

@end
