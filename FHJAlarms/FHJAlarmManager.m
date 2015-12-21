//
//  FHJAlarmManager.m
//  FHJAlarms
//
//  Created by fredhedz on 3/28/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJAlarmManager.h"

@interface FHJAlarmManager ()

@property (strong, nonatomic) NSMutableArray *alarmsArray;

@end

@implementation FHJAlarmManager

+ (FHJAlarmManager *)sharedInstance
{
    static FHJAlarmManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        _alarmsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self itemArchivePath]];
        if (!_alarmsArray) {
            _alarmsArray = [NSMutableArray new];
        }
    }
    
    return self;
}

- (FHJAlarm *)createAlarm
{
    FHJAlarm *newAlarm = [FHJAlarm new];
    
    [_alarmsArray addObject:newAlarm];
    
    return newAlarm;
}

- (NSArray *)allAlarms
{
    return [_alarmsArray copy];
}

- (BOOL)saveChanges
{
    
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.alarmsArray toFile:path];
}

- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"fhjalarm.data"];
}

- (void)removeAlarm:(FHJAlarm *)alarm
{
    [self.alarmsArray removeObjectIdenticalTo:alarm];
}

- (NSArray *)allFireDates
{
    NSMutableArray *allDates = [NSMutableArray new];
    NSArray *activeAlarms = [self allActiveAlarms];
    
    for (FHJAlarm *alarm in activeAlarms) {
        [allDates addObjectsFromArray:[alarm allFireDates]];
    }
    
    return [allDates copy];
}

- (NSArray *)allActiveAlarms
{
    NSMutableArray *result = [NSMutableArray new];
    for (FHJAlarm *alarm in _alarmsArray) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:alarm.alarmKey]) {
            [result addObject:alarm];
        }
    }
    
    return result;
}

@end
