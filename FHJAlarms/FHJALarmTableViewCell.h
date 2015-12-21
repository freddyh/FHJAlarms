//
//  FHJALarmTableViewCell.h
//  FHJAlarms
//
//  Created by fredhedz on 3/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHJALarmTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *masterSwitch;

@property (weak, nonatomic) NSString *alarmKey;

@end
