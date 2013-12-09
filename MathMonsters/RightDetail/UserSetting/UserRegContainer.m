//
//  UserRegContainer.m
//  MathMonsters
//
//  Created by Xcode on 13-12-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "UserRegContainer.h"
#import "MHTabBarController.h"
#import "UserRegByEmailVC.h"
#import "UserRegByPhoneVC.h"

@interface UserRegContainer ()

@end

@implementation UserRegContainer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
}

-(void)initComponents{
    
    UserRegByEmailVC *email = [[[UserRegByEmailVC alloc] init] autorelease];
    self.urEmailVC = email;
    
    UserRegByPhoneVC *phone = [[[UserRegByPhoneVC alloc] init] autorelease];
    self.urPhoneVC = phone;
    
    self.urEmailVC.title = @"邮箱注册";
    self.urPhoneVC.title = @"手机号注册";
    
    NSArray *viewControllers = [NSArray arrayWithObjects:self.urPhoneVC, self.urEmailVC, nil];
    MHTabBarController *h = [[[MHTabBarController alloc] init] autorelease];
	h.viewControllers = viewControllers;
    self.mhTab = h;
    [self addChildViewController:self.mhTab];
    [self.view addSubview:self.mhTab.view];
    
}


- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
