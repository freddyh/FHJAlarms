//
//  FHJALarmTableViewCell.m
//  FHJAlarms
//
//  Created by fredhedz on 3/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJALarmTableViewCell.h"

@implementation FHJALarmTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleMasterSwitch:(id)sender {
    
    BOOL enabled = _masterSwitch.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:self.alarmKey];
    
    //make the tint of the cell turn light gray if switch is off?
}

@end
