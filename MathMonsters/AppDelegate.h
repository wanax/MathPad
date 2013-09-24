//
//  AppDelegate.h
//  MathMonsters
//
//  Created by Xcode on 13-9-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGTabBarController.h"

@class RightViewController;
@class FontListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,NGTabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UISplitViewController *splitViewController;
@property (nonatomic,retain) RightViewController *right;
@property (nonatomic,retain) FontListViewController *left;

@end
