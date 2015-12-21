//
//  FHJAlarm.m
//  FHJAlarms
//
//  Created by fredhedz on 3/28/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJAlarm.h"

@implementation FHJAlarm

# pragma mark NSCoding Protocol

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.alarmName = [aDecoder decodeObjectForKey:@"alarmName"];
        self.repeatDays = [aDecoder decodeObjectForKey:@"repeatDays"];
        self.focus = [aDecoder decodeObjectForKey:@"focus"];
        self.dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        self.alarmKey = [aDecoder decodeObjectForKey:@"alarmKey"];
        self.fireTime = [aDecoder decodeObjectForKey:@"fireTime"];
//        self.thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        self.selectedFocusIndexes = [aDecoder decodeObjectForKey:@"selectedFocusIndexes"];
        self.repeatDaysIndexes = [aDecoder decodeObjectForKey:@"repeatDaysIndexes"];
        self.isEnabled = [aDecoder decodeBoolForKey:@"isEnabled"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.alarmName forKey:@"alarmName"];
    [aCoder encodeObject:self.repeatDays forKey:@"repeatDays"];
    [aCoder encodeObject:self.focus forKey:@"focus"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.alarmKey forKey:@"alarmKey"];
    [aCoder encodeObject:self.fireTime forKey:@"fireTime"];
    //[aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeObject:self.selectedFocusIndexes forKey:@"selectedFocusIndexes"];
    [aCoder encodeObject:self.repeatDaysIndexes forKey:@"repeatDaysIndexes"];
    [aCoder encodeBool:self.isEnabled forKey:@"isEnabled"];
}


//Consider: changing repeatDays NSArray to NSIndexSet
- (instancetype)initWithItemName:(NSString *)name
                      repeatDays:(NSArray *)repeatDays
                           focus:(NSArray *)focus;
{
    // Call the superclass's designated initializer
    self = [super init];
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        self.alarmName = name;
        self.repeatDays = repeatDays;
        self.dateCreated = [[NSDate alloc] init];
        self.selectedFocusIndexes = [NSIndexSet new];
        self.repeatDaysIndexes = [NSIndexSet new];
        
        // Create a NSUUID object - and get its string representation
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        self.alarmKey = key;
        self.isEnabled = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.alarmKey];
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)init {
    return [self initWithItemName:@"" repeatDays:@[] focus:@[]];
            
}

//Consider: Would a thumbnail be useful?
/*
- (void)setThumbnailWithImage:(UIImage *)image
{
    //The original image size
    CGSize origImageSize = image.size;
    
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 70, 70);
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context; keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Cleanup image context resources; we're done
    UIGraphicsEndImageContext();
}
 */

- (NSAttributedString *)timeString
{
    NSDate *date = _fireTime;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"h:mma"];
    
    NSString *timeString = [formatter stringFromDate:date];
    
    //length of string
    NSInteger timeStringLength = [timeString length];
    
    //range of the last two characters in timeString
    NSRange rangeOfLastTwoCharacters = NSMakeRange(timeStringLength - 2, 2);
        
    NSMutableAttributedString *mutableAttributedTimeString = [[NSMutableAttributedString alloc] initWithString:timeString];
    [mutableAttributedTimeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Georgia" size:14] range:rangeOfLastTwoCharacters];
    
    return mutableAttributedTimeString;
    
}

- (NSString *)daysString
{
    if ([_repeatDays count] == 0) {
        return @"Never";
    }

    NSString *result = nil;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSArray *allDays = [dateFormatter weekdaySymbols];
    NSArray *allDaysAbbr = [[dateFormatter shortWeekdaySymbols] mutableCopy];
    
    NSRange weekdaysRange = NSMakeRange(1, 5);
    NSRange everyDayRange = NSMakeRange(0, 7);

    NSIndexSet *weekdaySet = [[NSIndexSet alloc] initWithIndexesInRange:weekdaysRange];
    NSIndexSet *everydaySet = [[NSIndexSet alloc] initWithIndexesInRange:everyDayRange];
    NSMutableIndexSet *weekendSet = [NSMutableIndexSet new];
    [weekendSet addIndex:0];
    [weekendSet addIndex:6];
    
    if ([_repeatDays isEqualToArray:[allDays objectsAtIndexes:weekdaySet]]) {
        result = @"Weekdays";
    } else if ([_repeatDays isEqualToArray:[allDays objectsAtIndexes:weekendSet]]) {
        result = @"Weekends";
    } else if ([_repeatDays isEqualToArray:[allDays objectsAtIndexes:everydaySet]]) {
        result = @"Every day";
    } else {

        NSMutableArray *abbrDays = [NSMutableArray new];
        for (NSString *dayName in _repeatDays) {
            NSUInteger i = [allDays indexOfObject:dayName];
            [abbrDays addObject:[allDaysAbbr objectAtIndex:i]];
        }
        result = [abbrDays componentsJoinedByString:@" "];
    }
   
    return result;

}

- (NSString *)focusDescription
{
    return [_focus componentsJoinedByString:@" "];
}

- (NSString *)alarmName
{
    return ([_alarmName isEqualToString:@""]) ? @"No Name" : _alarmName;
    
}

- (NSAttributedString *)alarmDetails {
    
    if (![self.daysString isEqualToString:@"Never"] && ![self.alarmName isEqualToString:@""]) {
        
        //NSInteger lengthOfAlarmName = [self.alarmName length];
        
        NSMutableAttributedString *attributedAlarmDetailString = [[NSMutableAttributedString alloc] initWithString:self.alarmName attributes:@{NSFontAttributeName :[UIFont fontWithName:@"Georgia-Bold" size:14]}];
        NSMutableAttributedString *attributedDaysString = [[NSMutableAttributedString alloc] initWithString:self.daysString attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Georgia" size:14] }];
        NSAttributedString *attributedSpaceComma = [[NSAttributedString alloc] initWithString:@", "];
        [attributedAlarmDetailString appendAttributedString:attributedSpaceComma];
        [attributedAlarmDetailString appendAttributedString:attributedDaysString];
        
        return attributedAlarmDetailString;
    } else {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    return nil;
}

- (NSArray *)allFireDates
{
    NSMutableArray *allFireDates = [NSMutableArray new];
    
    if (_repeatDaysIndexes.count == 0) {
        //schedule the alarm once on the next weekday
        NSDate *nextFireDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:_fireTime];
        return @[nextFireDate];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSLog(@"fire date: %@", _fireTime);
    
    NSCalendarUnit weekdayUnits = NSCalendarUnitWeekday;
    NSCalendarUnit timeUnits = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *fireTimeComponents = [calendar components:timeUnits fromDate:_fireTime];
    NSDateComponents *nowTimeComponents = [calendar components:timeUnits fromDate:now];
    
    NSDateComponents *differenceComponents = [calendar components:timeUnits fromDateComponents:nowTimeComponents toDateComponents:fireTimeComponents options:0];
    
    NSDateComponents *dayComponent = [calendar components:weekdayUnits
                                                  fromDate:now];
    NSInteger currentWeekday = [dayComponent weekday];
    NSInteger nextDayIndex = [_repeatDaysIndexes firstIndex];
        
    while (nextDayIndex != NSNotFound)
    {
        //calculate the time between days
        //plus one because sunday = 1 and nextDayIndex first index = 0
        NSInteger convertedNextDayIndex = nextDayIndex + 1;
        NSInteger daysToAdd = convertedNextDayIndex - currentWeekday;
        NSTimeInterval offset = 0;
        
        if (daysToAdd < 0) {
            daysToAdd += 7;
        }
        
        if (daysToAdd == 0) {
            if (differenceComponents.minute < 0 || differenceComponents.second < 0 || differenceComponents.hour < 0) {
                daysToAdd = 7;
            } else {
                offset = labs(differenceComponents.hour * 3600) + labs(differenceComponents.minute * 60) + labs(differenceComponents.second);
            }
        }
        
        NSTimeInterval secondsToAdd = daysToAdd*60*60*24 + offset;
        
        //add the number of seconds
        NSDate *nextFireDate = [calendar dateByAddingUnit:NSCalendarUnitSecond value:secondsToAdd toDate:now options:0];
        [allFireDates addObject:nextFireDate];
        
        //increment
        nextDayIndex = [_repeatDaysIndexes indexGreaterThanIndex: nextDayIndex];
    }
    
    NSLog(@"Now: %@", [NSDate date]);
    for (NSDate *date in allFireDates) {
        NSLog(@"Fire Date %@", date);
    }
    
    return [allFireDates copy];
}

@end
