//
//  FInanceDetailViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-1.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FInanceDetailViewController.h"

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
	self.view.frame=CGRectMake(0,0,200,200);
    UIViewController *fuck=[[UIViewController alloc] init];
    fuck.view.frame=CGRectMake(0,0,200,200);
    fuck.view.backgroundColor=[UIColor magentaColor];
    [self.view addSubview:fuck.view];
    self.view.backgroundColor=[UIColor purpleColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
