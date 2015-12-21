//
//  QuotesManager.m
//  YouLittleWeakling
//
//  Created by fredhedz on 7/9/14.
//  Copyright (c) 2014 Freddy Hernandez Jr. All rights reserved.
//

#import "QuotesManager.h"

@interface QuotesManager()

@property (nonatomic) NSMutableDictionary *indexes;

@end

@implementation QuotesManager

+ (QuotesManager *)sharedInstance
{
    static QuotesManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.indexes = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"indexes_dictionary"] mutableCopy];
        if (!self.indexes) {
            self.indexes = [NSMutableDictionary new];
        }
    }
    return self;
}

- (NSArray *)allFocuses
{
    return @[@"Diet", @"Exercise", @"Creativity", @"Life", @"Love", @"Study"    ];
}

- (NSMutableArray *)indexesForCategory:(NSString *)categoryName
{
    NSMutableArray *result = self.indexes[categoryName];
    if (!result) {
        result = [NSMutableArray new];
    }
    return result;
    
}

- (void)saveIndexes:(NSArray *)indexes forCategory:(NSString *)categoryName
{
    self.indexes[categoryName] = indexes;
    [[NSUserDefaults standardUserDefaults] setObject:self.indexes forKey:@"indexes_dictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)quoteForFocus:(NSArray *)focusArray
{
    NSInteger randomIndex = random() % focusArray.count;
    return [self quoteforCategory:focusArray[randomIndex]];
}

- (NSString*)quoteforCategory:(NSString*)categoryName
{
    //initialize the array with lines from text file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_quotes", categoryName] ofType:@".txt"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString *fileContents = [[NSString alloc] initWithBytes:[fileData bytes] length:[fileData length] encoding:NSUTF8StringEncoding];
    NSArray *quotesArray = [fileContents componentsSeparatedByString:@"\n"];
    NSMutableArray *usedIndexes = [[self indexesForCategory:categoryName] mutableCopy];
    
    //pick a random index that has not been used
    NSNumber *randomIndex = nil;
    while (randomIndex == nil) {
        randomIndex = [NSNumber numberWithInteger:(random() % quotesArray.count)];
        if ([usedIndexes containsObject:randomIndex]) {
            randomIndex = nil;
        }
    }
    
    //add the new index to the front
    [usedIndexes insertObject:randomIndex atIndex:0];
    
    //trim the array if it is maxed
    if (usedIndexes.count >= 20) {
        [usedIndexes removeLastObject];
    }
    
    [self saveIndexes:usedIndexes forCategory:categoryName];

    return quotesArray[randomIndex.integerValue];
}

@end