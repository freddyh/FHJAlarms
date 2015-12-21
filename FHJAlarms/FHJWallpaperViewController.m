//
//  FHJWallpaperViewController.m
//  FHJAlarms
//
//  Created by fredhedz on 4/2/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "FHJWallpaperViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface FHJWallpaperViewController ()

@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;

@property (weak, nonatomic) UIImage *image;

@end

@implementation FHJWallpaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_quoteLabel setText:_quote];
    
    UINavigationItem *navItem = self.navigationItem;
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [titleView setText:_wallpaperTitle];
    [titleView setTextColor:[UIColor whiteColor]];
    
    navItem.titleView = titleView;
    
        
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)actionButtonTapped:(id)sender {
    
    NSArray *shareObj =@[_quote];

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:shareObj applicationActivities:@[]];
    activityViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:activityViewController animated:YES completion:NULL];
    [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        NSLog(@"Activity Type: %@", activityType);
    }];
}

@end
