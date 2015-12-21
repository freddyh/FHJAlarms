//
//  FHJAlarmManager.h
//  FHJAlarms
//
//  Created by fredhedz on 3/28/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHJAlarm.h"

@interface FHJAlarmManager : NSObject

+ (FHJAlarmManager *)sharedInstance;

- (FHJAlarm *)createAlarm;

- (NSArray *)allAlarms;
- (NSArray *)allFireDates;
- (NSArray *)allActiveAlarms;

- (void)removeAlarm:(FHJAlarm *)alarm;

- (BOOL)saveChanges;

@end
