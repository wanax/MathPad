//
//  AppDelegate.h
//  MathMonsters
//
//  Created by Xcode on 13-9-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerticalTabBarViewController;
@class REFrostedViewController;
@class SettingNavigationController;
@class SettingMenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) VerticalTabBarViewController *verTabBar;
@property (nonatomic,retain) REFrostedViewController *frostedViewController;
@property (nonatomic,retain) SettingNavigationController *navigationController;
@property (nonatomic,retain) SettingMenuViewController *menuController;

@property (nonatomic,strong) id comInfo;
@property (nonatomic,retain) NSTimer *loginTimer;
@property BOOL isReachable;
//@property (nonatomic,retain) id<LeftBarDelegate> delegate;

@end
