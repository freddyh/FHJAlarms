//
//  FHJDaysTableViewController.m
//  FHJAlarms
//
//  Created by fredhedz on 3/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJDaysTableViewController.h"

@interface FHJDaysTableViewController ()

@property (strong, nonatomic) NSArray *daysArray;
//@property (strong, nonatomic) NSMutableArray *fhjDaysTableData;
@property (strong, nonatomic) NSMutableIndexSet *selectedIndexes;

@end

@implementation FHJDaysTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDaysData];
    
    //_fhjDaysTableData = [NSMutableArray new];
    //[self loadFHJDaysTableData];
    
    UINavigationItem *navItem = self.navigationItem;
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.text = @"You Weakling";
    navTitle.backgroundColor = [UIColor whiteColor];
    navTitle.textColor = [UIColor greenColor];
    
    navItem.titleView = navTitle;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DayCell"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _alarm.repeatDays = [self selectedDays];
    _alarm.repeatDaysIndexes = [_selectedIndexes copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_daysArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"DayCell"];
    }

    // Configure the cell...
    NSString *day = _daysArray[indexPath.row];
    NSString *fullText = [NSString stringWithFormat:@"Every %@", day];
    cell.textLabel.text = fullText;
    
    cell.accessoryType = [_selectedIndexes containsIndex:indexPath.row] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delgate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_selectedIndexes containsIndex:indexPath.row]) {
        [_selectedIndexes removeIndex:indexPath.row];
    } else {
        [_selectedIndexes addIndex:indexPath.row];
    }
    
//    if (indexPath.section == 1) {
//        
//        NSRange fhjRange = NSMakeRange(0, 7);
//        NSIndexSet *everydayIndexSet = [NSIndexSet indexSetWithIndexesInRange:fhjRange];
//        _selectedIndexes = [everydayIndexSet mutableCopy];
//    }
//    
//    if (indexPath.section == 2) {
//        NSRange fhjRange = NSMakeRange(1, 5);
//        NSIndexSet *everydayIndexSet = [NSIndexSet indexSetWithIndexesInRange:fhjRange];
//        _selectedIndexes = [everydayIndexSet mutableCopy];
//        
//    }
//    
//    if (indexPath.section == 3) {
//        
//        NSMutableIndexSet *everydayIndexSet = [[NSMutableIndexSet alloc] init];
//        [everydayIndexSet addIndex:0];
//        [everydayIndexSet addIndex:6];
//        _selectedIndexes = [everydayIndexSet mutableCopy];
//        
//    }
    
    
    
    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
}

- (NSArray *)selectedDays
{
    if ([_selectedIndexes count] == 0) {
        return nil;
    }
    
    NSMutableArray *selectedDays = [NSMutableArray new];
    
    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSString *dayOfTheWeek = self->_daysArray[idx];
        [selectedDays addObject:dayOfTheWeek];
    }];
    
    return [selectedDays copy];
}

/*
- (void)loadFHJDaysTableData{
    
    NSRange weekdaysRange = NSMakeRange(0, 7);
    
    NSIndexSet *weekdayIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:weekdaysRange];
    
    [_fhjDaysTableData addObject:[_daysArray objectsAtIndexes:weekdayIndexSet]];
    
    [_fhjDaysTableData addObject:@[@"Every day"]];
    [_fhjDaysTableData addObject:@[@"Weekdays"]];
    [_fhjDaysTableData addObject:@[@"Weekends"]];
    
} */

- (void)loadDaysData {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    _daysArray = [dateFormatter weekdaySymbols];
    if (_alarm) {
        _selectedIndexes = [_alarm.repeatDaysIndexes mutableCopy];
    } else {
        _selectedIndexes = [NSMutableIndexSet new];
    }
    
    
}

@end

