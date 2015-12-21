//
//  QuotesManager.h
//  YouLittleWeakling
//
//  Created by fredhedz on 7/9/14.
//  Copyright (c) 2014 Freddy Hernandez Jr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuotesManager : NSObject

+ (QuotesManager *)sharedInstance;

- (NSString *)quoteForFocus:(NSArray *)focusArray;

- (NSArray *)allFocuses;

@end
