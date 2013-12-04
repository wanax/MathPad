//
//  NewReportViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "NewReportViewController.h"
#import "NewReportIndicator.h"
#import "NewReportCell.h"
#import "NewComCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVPullToRefresh.h"
#import "NewReportLeftListViewController.h"
#import "NewReportRightListViewController.h"

@interface NewReportViewController ()

@end

@implementation NewReportViewController

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

    self.view.backgroundColor=[UIColor blackColor];
    [self initComponents];
}

-(void)initComponents{
    
    UIImageView *backImgView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newReportBackImg"]] autorelease];
    backImgView.frame=CGRectMake(0,0,924,716);
    [self.view addSubview:backImgView];

    NewReportIndicator *indicator=[[[NewReportIndicator alloc] initWithFrame:CGRectMake(0,0, 924, 60)] autorelease];
    [self.view addSubview:indicator];
    
    NewReportLeftListViewController *leftList=[[[NewReportLeftListViewController alloc] init] autorelease];
    leftList.view.frame=CGRectMake(4,60,568,1000);
    [self.view addSubview:leftList.view];
    [self addChildViewController:leftList];
    
    NewReportRightListViewController *rightList=[[[NewReportRightListViewController alloc] init] autorelease];
    rightList.view.frame=CGRectMake(570,60,340,1000);
    [self.view addSubview:rightList.view];
    [self addChildViewController:rightList];
    
}

- (BOOL)shouldAutorotate{
    return YES;
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
