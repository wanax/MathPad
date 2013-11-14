//
//  FSViewController.m
//  FSVerticalTabBarExample
//
//  Created by Truman, Christopher on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSVerticalTabBarExampleController.h"
#import "FSVerticalTabBarController.h"
#import "PieViewController.h"
#import "LeftBarViewController.h"
#import "ValuModelViewController.h"
#import "DailyStockViewController.h"
#import "NewReportViewController.h"
#import "ValueModelChartViewController.h"
#import "MyGooGuuViewController.h"
#import "GraphExchangeViewController.h"
#import "FinanceToolViewController.h"
#import "SettingViewController.h"
#import "REFrostedViewController.h"

@interface FSVerticalTabBarExampleController () {
    NSArray* viewControllers;
}
    
@end

@implementation FSVerticalTabBarExampleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    UIImageView *topBar=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topBarBack"]];
    topBar.frame=CGRectMake(0,0,SCREEN_HEIGHT,55);
    [self.view addSubview:topBar];
    
    UILabel *barTitle=[[UILabel alloc] initWithFrame:CGRectMake(475,10,100,35)];
    [barTitle setText:@"估股"];
    [barTitle setFont:[UIFont fontWithName:@"Heiti SC" size:30]];
    [barTitle setTextColor:[Utiles colorWithHexString:@"fffbf2"]];
    [topBar addSubview:barTitle];
    
    UIButton *questionBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [questionBt setFrame:CGRectMake(20,14,28,28)];
    [questionBt setBackgroundImage:[UIImage imageNamed:@"topQuestion"] forState:UIControlStateNormal];
    [questionBt addTarget:self action:@selector(questionBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBt];
    
    NSMutableArray* controllersToAdd = [[NSMutableArray alloc] init];
    
    DailyStockViewController *vc1=[[DailyStockViewController alloc] init];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"dailyStockBt.png"] tag: 0];
    [controllersToAdd addObject:vc1];
    
    NewReportViewController *vc2=[[NewReportViewController alloc] init];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"newReportBt.png"] tag: 1];
    [controllersToAdd addObject:vc2];
    
    UITabBarController *tabBarController=[[[UITabBarController alloc] init] autorelease];
    [tabBarController.tabBar setItemPositioning:UITabBarItemPositioningFill];
    UITabBarItem *barItem=[[[UITabBarItem alloc] init] autorelease];
    [barItem setTitle:@"港股"];
    UITabBarItem *barItem2=[[UITabBarItem alloc] initWithTitle:@"美股" image:[UIImage imageNamed:@"myGooGuuBar"] tag:2];
    UITabBarItem *barItem3=[[UITabBarItem alloc] initWithTitle:@"深市" image:[UIImage imageNamed:@"hammer.png"] tag:3];
    UITabBarItem *barItem4=[[UITabBarItem alloc] initWithTitle:@"沪市" image:[UIImage imageNamed:@"moreAboutBar"] tag:4];
    ValuModelViewController * vc11 = [[[ValuModelViewController alloc] init] autorelease];
    [vc11 setMarketType:HK];
    //vc11.view.frame=CGRectMake(0,0,924,600);
    ValuModelViewController * vc22 = [[[ValuModelViewController alloc] init] autorelease];
    [vc22 setMarketType:NANY];
    ValuModelViewController * vc33 = [[[ValuModelViewController alloc] init] autorelease];
    [vc33 setMarketType:SZSE];
    ValuModelViewController * vc44 = [[[ValuModelViewController alloc] init] autorelease];
    [vc44 setMarketType:SHSE];
    vc11.tabBarItem=barItem;
    vc22.tabBarItem=barItem2;
    vc33.tabBarItem=[barItem3 autorelease];
    vc44.tabBarItem=[barItem4 autorelease];
    tabBarController.viewControllers=[NSArray arrayWithObjects:vc11,vc22,vc33,vc44, nil];
    tabBarController.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"newReportBt.png"] tag: 2];
    [controllersToAdd addObject:tabBarController];
    
    MyGooGuuViewController *vc4=[[MyGooGuuViewController alloc] init];
    vc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"myGooguuBt.png"] tag: 3];
    [controllersToAdd addObject:vc4];
    
    GraphExchangeViewController *vc5=[[GraphExchangeViewController alloc] init];
    vc5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"graphExchangeBt.png"] tag: 4];
    [controllersToAdd addObject:vc5];
    
    FinanceToolViewController *vc6=[[FinanceToolViewController alloc] init];
    vc6.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"financeToolBt.png"] tag: 5];
    [controllersToAdd addObject:vc6];
    
    SettingViewController *vc7=[[SettingViewController alloc] init];
    vc7.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"settingBt.png"] tag: 6];
    [controllersToAdd addObject:vc7];

    viewControllers = [NSArray arrayWithArray:controllersToAdd];

    [self setViewControllers:viewControllers];

    //[[self tabBar] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]]];
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor lightGrayColor].CGColor, nil];
    self.tabBar.backgroundGradientColors = colors;
    self.selectedViewController.view.frame=CGRectMake(0,55,824,713);
    self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:1]);
}


-(BOOL)tabBarController:(FSVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewControllers indexOfObject:viewController] == 6) {
        AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        [delegate.frostedViewController presentMenuViewController];
    }
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
