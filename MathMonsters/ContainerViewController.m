//
//  ContainViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-25.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ContainerViewController.h"
#import "PieViewController.h"
#import "LeftBarViewController.h"
#import "ValuModelViewController.h"
#import "DailyStockViewController.h"
#import "REFrostedViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isShowSetting=NO;
        _firstLaunch=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self addComponents];

}

-(void)viewDidAppear:(BOOL)animated{
    if (_firstLaunch) {
        [self setRightDetail:[[DailyStockViewController alloc] init]];
        _firstLaunch=NO;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)addComponents{
    
    UIImageView *rightViewBack=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightViewBack"]];
    rightViewBack.frame=CGRectMake(100,55,924,694);
    [self.view addSubview:rightViewBack];
    
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

    self.leftViewController=[[LeftBarViewController alloc] init];
    self.leftViewController.view.frame=CGRectMake(0,52,100,1024);
    self.leftViewController.delegate=self;
    [self.leftViewController.view setBackgroundColor:[UIColor blackColor]];
    [self addChildViewController:self.leftViewController];
    [self.view addSubview:self.leftViewController.view];
    
    [self setRightDetail:[[DailyStockViewController alloc] init]];
    
    self.searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(736,12, 263, 33)];
    self.searchBar.delegate=self;
    [self.view addSubview:self.searchBar];
    
    SAFE_RELEASE(barTitle);
    SAFE_RELEASE(topBar);
    
}

-(void)questionBtClicked:(id)sender{
    
    UIViewController *blue=[[UIViewController alloc] init];
    [blue.view setBackgroundColor:[Utiles colorWithHexString:@"#f4df76"]];
    [self setRightDetail:blue];
    
}

-(void)setRightDetail:(UIViewController *)rightViewController{

    if (self.rightViewController) {
        [self.rightViewController removeFromParentViewController];
        [self.rightViewController.view removeFromSuperview];
        self.rightViewController=nil;
    }
    
    self.rightViewController=rightViewController;
    self.rightViewController.view.frame=CGRectMake(100,52,923,720);
    [self addChildViewController:self.rightViewController];
    [self.view addSubview:self.rightViewController.view];

}


#pragma mark -
#pragma LeftBar Delegate

-(void)barChanged:(NSString *)controllerName{

    if(![controllerName isEqualToString:@"SettingViewController"]){
        if ([controllerName isEqualToString:@"ValuModelViewController"]) {
            UITabBarController *tabBarController=[[[UITabBarController alloc] init] autorelease];
            [tabBarController.tabBar setItemPositioning:UITabBarItemPositioningFill];
            UITabBarItem *barItem=[[[UITabBarItem alloc] init] autorelease];
            [barItem setTitle:@"港股"];            
            UITabBarItem *barItem2=[[UITabBarItem alloc] initWithTitle:@"美股" image:[UIImage imageNamed:@"myGooGuuBar"] tag:2];
            UITabBarItem *barItem3=[[UITabBarItem alloc] initWithTitle:@"深市" image:[UIImage imageNamed:@"hammer.png"] tag:3];
            UITabBarItem *barItem4=[[UITabBarItem alloc] initWithTitle:@"沪市" image:[UIImage imageNamed:@"moreAboutBar"] tag:4];
            ValuModelViewController * vc1 = [[[NSClassFromString(controllerName) alloc] init] autorelease];
            [vc1 setMarketType:HK];
            ValuModelViewController * vc2 = [[[NSClassFromString(controllerName) alloc] init] autorelease];
            [vc2 setMarketType:NANY];
            ValuModelViewController * vc3 = [[[NSClassFromString(controllerName) alloc] init] autorelease];
            [vc3 setMarketType:SZSE];
            ValuModelViewController * vc4 = [[[NSClassFromString(controllerName) alloc] init] autorelease];
            [vc4 setMarketType:SHSE];
            vc1.tabBarItem=barItem;
            vc2.tabBarItem=barItem2;
            vc3.tabBarItem=barItem3;
            vc4.tabBarItem=barItem4;
            tabBarController.viewControllers=[NSArray arrayWithObjects:vc1,vc2,vc3,vc4, nil];
            [self setRightDetail:tabBarController];
            [self.view addSubview:tabBarController.view];
        } else {
            UIViewController * vc = [[NSClassFromString(controllerName) alloc] init];
            [self setRightDetail:vc];
            SAFE_RELEASE(vc);
        }
        
    }else{        
        AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        [delegate.frostedViewController presentMenuViewController];
    }
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
