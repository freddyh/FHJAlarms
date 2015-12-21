//
//  FHJAlarm.h
//  FHJAlarms
//
//  Created by fredhedz on 3/28/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FHJAlarm : NSObject <NSCoding>

@property (strong, nonatomic) NSString *alarmName;
@property (strong, nonatomic) NSString *alarmKey;
@property (strong, nonatomic) NSAttributedString *alarmDetails;

//do i need this array of strings of day names
@property (strong, nonatomic) NSArray *repeatDays;
@property (strong, nonatomic) NSIndexSet *repeatDaysIndexes;
@property (strong, nonatomic) NSArray *focus;
@property (strong, nonatomic) NSIndexSet *selectedFocusIndexes;
@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *fireTime;
//@property (strong, nonatomic) UIImage *thumbnail;
@property (nonatomic) BOOL isEnabled;

- (instancetype)initWithItemName:(NSString *)name
                  repeatDays:(NSArray *)repeatDays
                           focus:(NSArray *)focus;

//- (void)setThumbnailWithImage:(UIImage *)image;

- (NSAttributedString *)timeString;
- (NSString *)daysString;
- (NSAttributedString *)alarmDetails;
- (NSString *)focusDescription;

- (NSArray *)allFireDates;



@end
