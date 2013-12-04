//
//  SettingNavigationController.h
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "SettingNavigationController.h"
#import "SettingMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface SettingNavigationController ()

@property (strong, readwrite, nonatomic) SettingMenuViewController *menuViewController;

@end

@implementation SettingNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setHidden:YES];
}

- (void)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

- (BOOL)shouldAutorotate{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

@end
