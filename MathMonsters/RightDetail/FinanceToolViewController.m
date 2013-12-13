//
//  FinanceToolViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinanceToolViewController.h"
#import "FinanceToolLeftListViewController.h"
#import "CounterViewController.h"
#import "MGSplitViewController.h"
#import "FlatUIKit.h"

@interface FinanceToolViewController ()

@end

@implementation FinanceToolViewController

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
    self.view.backgroundColor=[Utiles colorWithHexString:@"#26160D"];
    [self initComponents];
}

-(void)toolChanged:(NSString *)pName pUnit:(NSString *)pUnit rName:(NSString *)rName rUnit:(NSString *)rUnit type:(FinancalToolsType)type{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:pName,@"pName",pUnit,@"pUnit",rName,@"rName",rUnit,@"rUnit", nil];
    self.detail.params=params;
    self.detail.toolType=type;
    [self.detail viewWillAppear:YES];
}

-(void)initComponents{
    
    UIImageView *backView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finToolBack"]] autorelease];
    [self.view addSubview:backView];
    
    FinanceToolLeftListViewController *leftList=[[[FinanceToolLeftListViewController alloc] init] autorelease];
    leftList.delegate=self;
    UINavigationController *leftListNav=[[[UINavigationController alloc] initWithRootViewController:leftList] autorelease];
    leftListNav.view.backgroundColor=[UIColor greenSeaColor];
    
    CounterViewController *countVC = [[[CounterViewController alloc] init] autorelease];
    self.detail = countVC;
    UINavigationController *detailNav=[[[UINavigationController alloc] initWithRootViewController:self.detail] autorelease];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"贝塔系数,债务占比,有效税率",@"pName",@"0,%,%",@"pUnit",@"股权占比,无杠杆贝塔系数",@"rName",@"%,1",@"rUnit", nil];
    self.detail.params=params;
    self.detail.toolType=BetaFactor;

    MGSplitViewController *split=[[[MGSplitViewController alloc] init] autorelease];
    split.view.frame=CGRectMake(0,0,928,1200);
    split.splitPosition=200;
    split.viewControllers=@[leftListNav,detailNav];
    split.view.backgroundColor=[UIColor grayColor];

    [self.view addSubview:split.view];
    [self addChildViewController:split];
    
}


-(void)addButtons:(NSString *)title fun:(SEL)fun frame:(CGRect)rect icon:(NSString *)icon{
    
    UIImageView *iconImg=[[[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x-52,rect.origin.y,52,49)] autorelease];
    [iconImg setImage:[UIImage imageNamed:icon]];
    [self.view addSubview:iconImg];
    
    FUIButton *bt=[FUIButton buttonWithType:UIButtonTypeCustom];
    [bt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:17.0]];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setFrame:rect];
    bt.buttonColor = [Utiles colorWithHexString:@"#40261C"];
    [bt setSelected:YES];
    bt.shadowHeight = 2.0f;
    bt.cornerRadius = 0.0f;
    [bt setTitleColor:[Utiles colorWithHexString:@"#fedbe3"] forState:UIControlStateNormal];
    [bt addTarget:self action:fun forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
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
