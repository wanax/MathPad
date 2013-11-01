//
//  FinanceToolViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinanceToolViewController.h"
#import "FinanceToolLeftListViewController.h"
#import "FInanceDetailViewController.h"
#import "MGSplitViewController.h"
#import "MGSplitDividerView.h"
#import "MGSplitCornersView.h"
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
	[self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor=[Utiles colorWithHexString:@"#26160D"];
    [self initComponents];
}

-(void)initComponents{
    
    UIImageView *backView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finToolBack"]] autorelease];
    [self.view addSubview:backView];
    
    UIImageView *rightBackView=[[[UIImageView alloc] initWithFrame:CGRectMake(273,80,628,568)] autorelease];
    [rightBackView setImage:[UIImage imageNamed:@"finToolRightBack"]];
    //[self.view addSubview:rightBackView];
    
    FinanceToolLeftListViewController *test=[[FinanceToolLeftListViewController alloc] init];
    //test.view.frame=CGRectMake(0,0,80,568);
    UINavigationController *testNav=[[UINavigationController alloc] initWithRootViewController:test];
    
    FInanceDetailViewController *detail=[[FInanceDetailViewController alloc] init];
    detail.view.frame=CGRectMake(0,0,50,50);
    
    MGSplitViewController *split=[[MGSplitViewController alloc] init];
    split.view.frame=CGRectMake(80,80,1000,1000);
    split.showsMasterInLandscape=YES;
    split.detailViewController.view.frame=CGRectMake(0,0,200,200);
    //split.dividerView.splitViewController.view.frame=CGRectMake(40,80,600,870);
    split.dividerStyle=MGSplitViewDividerStylePaneSplitter;
    split.viewControllers=@[testNav,detail];
    split.view.backgroundColor=[UIColor grayColor];
    split.allowsDraggingDivider=YES;
    [self.view addSubview:split.view];
    [self addChildViewController:split];
    
    //[self.view addSubview:testNav.topViewController.view];
    //[self addChildViewController:testNav];
    
    /*self.cusTable=[[UITableView alloc] initWithFrame:CGRectMake(80,80,184,568)];
    self.cusTable.dataSource=self;
    self.cusTable.delegate=self;
    [self.cusTable setBackgroundColor:[Utiles colorWithHexString:@"#22130B"]];
    self.cusTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cusTable];*/
    
    /*[self addButtons:@"计算贝塔系数" fun:Nil frame:CGRectMake(92,80,172,52) icon:@"BETA"];
    [self addButtons:@"计算折现率" fun:Nil frame:CGRectMake(92,132,172,52) icon:@"WACC"];
    [self addButtons:@"自由现金流计算" fun:Nil frame:CGRectMake(92,184,172,52) icon:@"FREECRASH"];
    [self addButtons:@"现金流折现工具" fun:Nil frame:CGRectMake(92,236,172,52) icon:@"CASHCOUNT"];
    [self addButtons:@"初创公司估值" fun:Nil frame:CGRectMake(92,288,172,52) icon:@"COMVALU"];
    [self addButtons:@"PE投资回报计算" fun:Nil frame:CGRectMake(92,340,172,52) icon:@"PE"];
    [self addButtons:@"资金的时间价值计算" fun:Nil frame:CGRectMake(92,392,172,52) icon:@"FUNDTIME"];
    [self addButtons:@"投资收益计算" fun:Nil frame:CGRectMake(92,444,172,52) icon:@"INVESTCOM"];
    [self addButtons:@"A股交易手续费计算器" fun:Nil frame:CGRectMake(92,496,172,52) icon:@"ASTOCK"];
    [self addButtons:@"港股交易手续费计算器" fun:Nil frame:CGRectMake(92,548,172,52) icon:@"HSTOCK"];
    [self addButtons:@"金融建模Excel快捷键" fun:Nil frame:CGRectMake(92,600,172,52) icon:@"EXCEL"];*/
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
