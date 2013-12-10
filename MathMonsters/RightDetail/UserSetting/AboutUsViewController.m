//
//  AboutUsViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-12-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
	
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bt setTitle:@"我已了解" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt setFrame:CGRectMake(210,380,120,30)];
    bt.titleLabel.textAlignment = NSTextAlignmentLeft;
    bt.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    bt.backgroundColor = [UIColor carrotColor];
    [bt addTarget:self action:@selector(viewDisMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

-(void)viewDisMiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
