//
//  FInanceDetailViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-1.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FInanceDetailViewController.h"
#import "UIColor+FlatUI.h"

@interface FInanceDetailViewController ()

@end

@implementation FInanceDetailViewController

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
    UIImageView *rightBackView=[[[UIImageView alloc] initWithFrame:CGRectMake(0,0,630,568)] autorelease];
    [rightBackView setImage:[UIImage imageNamed:@"finToolRightBack"]];
    [self.view addSubview:rightBackView];
}






- (BOOL)shouldAutorotate{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
