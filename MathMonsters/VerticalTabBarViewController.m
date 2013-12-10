//
//  FSViewController.m
//  FSVerticalTabBarExample
//
//  Created by Truman, Christopher on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VerticalTabBarViewController.h"
#import "FSVerticalTabBarController.h"
#import "PieViewController.h"
#import "ValuModelContainerViewController.h"
#import "DailyStockViewController.h"
#import "NewReportViewController.h"
#import "ValueModelChartViewController.h"
#import "MyGooGuuViewController.h"
#import "GraphExchangeViewController.h"
#import "FinanceToolViewController.h"
#import "SettingViewController.h"
#import "REFrostedViewController.h"
#import "GooGuuViewListViewController.h"
#import "SearchComListViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ClientLoginViewController.h"

@interface VerticalTabBarViewController () {
    NSArray* viewControllers;
}
    
@end

@implementation VerticalTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
}

-(void)questionBtClicked:(UIButton *)bt{
    
}

-(void)loginBtClicked:(UIButton *)bt {
    
    ClientLoginViewController *loginVC = [[ClientLoginViewController alloc] init];
    loginVC.sourceType=VerticalTabBar;
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

#pragma mark -
#pragma UIPopVC Methods Delegate

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [self.searchBar resignFirstResponder];
}

#pragma mark -
#pragma UISearchBar Methods Delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    [self.popVC presentPopoverFromRect:CGRectMake(770,00,240,55) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSDictionary *param = @{@"q":searchText};
    [Utiles getNetInfoWithPath:@"QueryComList" andParams:param besidesBlock:^(id obj) {
        
        self.searchListVC.companys=obj;
        [self.searchListVC.comTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)initComponents{
    
    self.delegate = self;
    
    UIImageView *topBar=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topBarBack"]] autorelease];
    topBar.frame=CGRectMake(0,0,SCREEN_HEIGHT,55);
    [self.view addSubview:topBar];
    
    UILabel *barTitle=[[[UILabel alloc] initWithFrame:CGRectMake(475,10,100,35)] autorelease];
    [barTitle setText:@"估股"];
    [barTitle setFont:[UIFont fontWithName:@"Heiti SC" size:30]];
    [barTitle setTextColor:[Utiles colorWithHexString:@"#fffbf2"]];
    [topBar addSubview:barTitle];
    
    UIButton *questionBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [questionBt setFrame:CGRectMake(20,14,28,28)];
    [questionBt setBackgroundImage:[UIImage imageNamed:@"topQuestion"] forState:UIControlStateNormal];
    [questionBt addTarget:self action:@selector(questionBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionBt];
    
    UIButton *loginBt=[UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([Utiles isLogin]) {
        [loginBt setFrame:CGRectMake(60,14,200,30)];
        id userInfo = GetUserDefaults(@"UserInfo");
        [loginBt setTitle:userInfo[@"username"] forState:UIControlStateDisabled];
        loginBt.enabled = NO;
    } else {
        [loginBt setTitle:@"登录" forState:UIControlStateNormal];
        [loginBt setFrame:CGRectMake(60,14,60,30)];
    }
    
    [loginBt addTarget:self action:@selector(loginBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBt];
    
    UISearchBar *bar=[[[UISearchBar alloc] initWithFrame:CGRectMake(770,00,240,55)] autorelease];
    bar.delegate=self;
    bar.placeholder=@"拼音/代码/全称";
    bar.backgroundColor=[UIColor clearColor];
    bar.barTintColor=[UIColor clearColor];
    self.searchBar=bar;
    [self.view addSubview:self.searchBar];
    
    SearchComListViewController *st = [[[SearchComListViewController alloc] init] autorelease];
    self.searchListVC=st;
    UIPopoverController *p=[[[UIPopoverController alloc] initWithContentViewController:self.searchListVC] autorelease];
    self.popVC=p;
    self.popVC.delegate=self;
    
    NSMutableArray* controllersToAdd = [[[NSMutableArray alloc] init] autorelease];
    
    DailyStockViewController *vc1=[[[DailyStockViewController alloc] init] autorelease];
    vc1.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"dailyStockBt.png"] selectedImage:[UIImage imageNamed:@"dailyStockBtSe.png"]] autorelease];
    [controllersToAdd addObject:vc1];
    
    NewReportViewController *vc2=[[[NewReportViewController alloc] init] autorelease];
    vc2.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"newReportBt.png"] selectedImage:[UIImage imageNamed:@"newReportBtSe.png"]] autorelease];
    [controllersToAdd addObject:vc2];
    
    GooGuuViewListViewController *gView=[[[GooGuuViewListViewController alloc] init] autorelease];
    gView.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"googuuViewBt"] selectedImage:[UIImage imageNamed:@"googuuViewBtSe"]] autorelease];
    [controllersToAdd addObject:gView];
    
    UITabBarController *tabBarController=[[[UITabBarController alloc] init] autorelease];
    [tabBarController.tabBar setItemPositioning:UITabBarItemPositioningFill];
    UITabBarItem *barItem=[[[UITabBarItem alloc] initWithTitle:@"港股" image:[UIImage imageNamed:@"HK"] tag:1] autorelease];
    UITabBarItem *barItem2=[[[UITabBarItem alloc] initWithTitle:@"美股" image:[UIImage imageNamed:@"NASC"] tag:2] autorelease];
    UITabBarItem *barItem3=[[[UITabBarItem alloc] initWithTitle:@"深市" image:[UIImage imageNamed:@"SZ"] tag:3] autorelease];
    UITabBarItem *barItem4=[[[UITabBarItem alloc] initWithTitle:@"沪市" image:[UIImage imageNamed:@"SH"] tag:4] autorelease];
    ValuModelContainerViewController * vc11 = [[[ValuModelContainerViewController alloc] initWithType:HK] autorelease];
    ValuModelContainerViewController * vc22 = [[[ValuModelContainerViewController alloc] initWithType:NANY] autorelease];
    ValuModelContainerViewController * vc33 = [[[ValuModelContainerViewController alloc] initWithType:SZSE] autorelease];
    ValuModelContainerViewController * vc44 = [[[ValuModelContainerViewController alloc] initWithType:SHSE] autorelease];
    vc11.tabBarItem=barItem;
    vc22.tabBarItem=barItem2;
    vc33.tabBarItem=barItem3;
    vc44.tabBarItem=barItem4;
    tabBarController.viewControllers=[NSArray arrayWithObjects:vc11,vc22,vc33,vc44, nil];
    tabBarController.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"valuModelBt"] selectedImage:[UIImage imageNamed:@"valuModelBtSe"]] autorelease];
    [controllersToAdd addObject:tabBarController];
    
    MyGooGuuViewController *vc4=[[[MyGooGuuViewController alloc] init] autorelease];
    vc4.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"myGooguuBt.png"] selectedImage:[UIImage imageNamed:@"myGooguuBtSe.png"]] autorelease];
    [controllersToAdd addObject:vc4];
    
    GraphExchangeViewController *vc5=[[[GraphExchangeViewController alloc] init] autorelease];
    vc5.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"graphExchangeBt.png"] selectedImage:[UIImage imageNamed:@"graphExchangeBtSe.png"]] autorelease];
    [controllersToAdd addObject:vc5];
    
    FinanceToolViewController *vc6=[[[FinanceToolViewController alloc] init] autorelease];
    vc6.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"financeToolBt.png"] selectedImage:[UIImage imageNamed:@"financeToolBtSe.png"]] autorelease];
    [controllersToAdd addObject:vc6];
    
    SettingViewController *vc7=[[[SettingViewController alloc] init] autorelease];
    vc7.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"title" image:[UIImage imageNamed:@"settingBt.png"] selectedImage:[UIImage imageNamed:@"settingBtSe.png"]] autorelease];
    [controllersToAdd addObject:vc7];
    
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    [self setViewControllers:viewControllers];
    
    [[self tabBar] setBackgroundColor:[UIColor peterRiverColor]];
    

}


-(BOOL)tabBarController:(FSVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewControllers indexOfObject:viewController] == 7) {
        AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        [delegate.frostedViewController presentMenuViewController];
    }
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
