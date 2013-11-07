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
#import "FInanceDetailViewController.h"
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
    
    FinanceToolLeftListViewController *leftList=[[FinanceToolLeftListViewController alloc] init];
    leftList.delegate=self;
    UINavigationController *leftListNav=[[UINavigationController alloc] initWithRootViewController:leftList];
    leftListNav.view.backgroundColor=[UIColor greenSeaColor];
    
    self.detail=[[CounterViewController alloc] init];
    UINavigationController *detailNav=[[UINavigationController alloc] initWithRootViewController:self.detail];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"贝塔系数,债务占比,有效税率",@"pName",@"0,%,%",@"pUnit",@"股权占比,无杠杆贝塔系数",@"rName",@"%,1",@"rUnit", nil];
    self.detail.params=params;
    self.detail.toolType=BetaFactor;

    MGSplitViewController *split=[[MGSplitViewController alloc] init];
    split.view.frame=CGRectMake(40,80,568,860);
    split.splitPosition=200;
    split.viewControllers=@[leftListNav,detailNav];
    split.view.backgroundColor=[UIColor grayColor];

    [self.view addSubview:split.view];
    [self addChildViewController:split];
    
    //[self logViewTreeForMainWindow];
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
