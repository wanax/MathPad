//
//  AppDelegate.h
//  MathMonsters
//
//  Created by Xcode on 13-9-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"
#import "LeftBarViewController.h"

@class RightViewController;
@class FontListViewController;
@class REFrostedViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) REFrostedViewController *frostedViewController;
@property (nonatomic,retain) UISplitViewController *splitViewController;
@property (nonatomic, retain) MGSplitViewController *split2ViewController;
@property (nonatomic,retain) RightViewController *right;
@property (nonatomic,retain) FontListViewController *left;

@property (nonatomic,retain) id<LeftBarDelegate> delegate;

@end
