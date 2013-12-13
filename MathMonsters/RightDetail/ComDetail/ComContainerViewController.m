//
//  ComContainerViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComContainerViewController.h"
#import "ComContainerIndicator.h"
#import "MHTabBarController.h"
#import "DahonValuationViewController.h"
#import "FinancalModelContainerViewController.h"
#import "ValuationModelContainerViewController.h"
#import "MyProLossContainerViewController.h"

@interface ComContainerViewController ()

@end

@implementation ComContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstLaunch=YES;
	[self initComponents];
}

-(void)initComponents{
    self.view.backgroundColor=[Utiles colorWithHexString:@"#F2EFE1"];
    self.title=[self.comInfo objectForKey:@"companyname"];

    NSDictionary *param=@{@"stockcode":self.comInfo[@"stockcode"]};
    [Utiles getNetInfoWithPath:@"GetCompanyInfo" andParams:param besidesBlock:^(id obj) {
        
        self.comInfo = obj;
        
        ComContainerIndicator *indicator=[[[ComContainerIndicator alloc] initWithFrame:CGRectMake(0,40, 1024, 60)] autorelease];
        indicator.comInfo=self.comInfo;
        [self.view addSubview:indicator];
        
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot:)];
        self.navigationItem.leftBarButtonItem = anotherButton;
        [anotherButton release];
        
        ValuationModelContainerViewController *temp1=[[[ValuationModelContainerViewController alloc] init] autorelease];
        temp1.sourceType=self.sourceType;
        self.valueContainer=temp1;
        
        FinancalModelContainerViewController *temp2=[[[FinancalModelContainerViewController alloc] init] autorelease];
        self.finContainer=temp2;
        
        DahonValuationViewController *temp3=[[[DahonValuationViewController alloc] init] autorelease];
        self.dahonContainer=temp3;
        
        MyProLossContainerViewController *temp4=[[[MyProLossContainerViewController alloc] init] autorelease];
        self.myProLossContainer=temp4;
        
        self.valueContainer.title=@"估值模型";
        self.valueContainer.comInfo=self.comInfo;
        self.finContainer.title=@"财务分析";
        self.finContainer.comInfo=self.comInfo;
        self.dahonContainer.title=@"大行估值";
        self.dahonContainer.comInfo=self.comInfo;
        self.myProLossContainer.title=@"我的损益表";
        self.myProLossContainer.comInfo=self.comInfo;
        
        NSArray *viewControllers = [NSArray arrayWithObjects:self.valueContainer, self.finContainer,self.dahonContainer,self.myProLossContainer, nil];
        MHTabBarController *h=[[[MHTabBarController alloc] init] autorelease];
        h.viewControllers = viewControllers;
        h.view.frame=CGRectMake(0,100,1024,700);
        self.tabBarController=h;
        [self addChildViewController:self.tabBarController];
        [self.view addSubview:self.tabBarController.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)backToRoot:(UIBarButtonItem *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
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
