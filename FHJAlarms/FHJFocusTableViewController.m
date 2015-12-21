//
//  FHJFocusTableViewController.m
//  FHJAlarms
//
//  Created by fredhedz on 3/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJFocusTableViewController.h"
#import "QuotesManager.h"

@interface FHJFocusTableViewController ()

@property (strong, nonatomic) NSArray *allFocuses;
@property (strong, nonatomic) NSMutableIndexSet *selectedIndexes;

@end

@implementation FHJFocusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _allFocuses = [[QuotesManager sharedInstance] allFocuses];
    
    if (_alarm) {
        _selectedIndexes = [_alarm.selectedFocusIndexes mutableCopy];
    } else {
        _selectedIndexes = [NSMutableIndexSet new];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FocusCell"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _alarm.focus = [self selectedFocuses];
    _alarm.selectedFocusIndexes = _selectedIndexes;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_allFocuses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FocusCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *focus = [_allFocuses objectAtIndex:indexPath.row];
    cell.textLabel.text = focus;
    
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
    
    cell.accessoryType = (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
}

- (NSArray *)selectedFocuses
{
    if ([_selectedIndexes count] == 0) {
        return nil;
    }
    
    NSMutableArray *selectedFocuses = [NSMutableArray new];
    
    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSString *focusString = _allFocuses[idx];
        [selectedFocuses addObject:focusString];
    }];
    
    return [selectedFocuses copy];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
