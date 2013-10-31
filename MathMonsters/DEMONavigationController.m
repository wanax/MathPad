//
//  DEMONavigationController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMONavigationController.h"
#import "DEMOMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface DEMONavigationController ()

@property (strong, readwrite, nonatomic) DEMOMenuViewController *menuViewController;

@end

@implementation DEMONavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setHidden:YES];
}

- (void)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

@end
