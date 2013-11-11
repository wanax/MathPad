//
//  ComContainerViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComContainerViewController.h"
#import "ComContainerIndicator.h"
#import "DahonValuationViewController.h"
#import "FinancalModelChartViewController.h"
#import "FinancalModelContainerViewController.h"

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
    if (_firstLaunch) {
        DahonValuationViewController *vc=[[DahonValuationViewController alloc] init];
        vc.comInfo=self.comInfo;
        [self setDetailVC:vc];
        SAFE_RELEASE(vc);
        _firstLaunch=NO;
    }
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
    
    ComContainerIndicator *indicator=[[[ComContainerIndicator alloc] initWithFrame:CGRectMake(0,40, 1024, 60)] autorelease];
    indicator.comInfo=self.comInfo;
    [self.view addSubview:indicator];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot:)];
    self.navigationItem.leftBarButtonItem = anotherButton;
    [anotherButton release];
    
    [self addButtons:@"大行估值" fun:@selector(changeDetailVC:) frame:CGRectMake(0,100, 256, 50) type:DahonModel];
    [self addButtons:@"财务数据" fun:@selector(changeDetailVC:) frame:CGRectMake(256,100, 256, 50) type:FinancalModel];
    [self addButtons:@"估值模型" fun:@selector(changeDetailVC:) frame:CGRectMake(512,100, 256, 50) type:DragabelModel];
    [self addButtons:@"我的损益表" fun:@selector(changeDetailVC:) frame:CGRectMake(768,100, 256, 50) type:MyProAndLossTable];
}

-(void)addButtons:(NSString *)title fun:(SEL)fun frame:(CGRect)rect type:(ChartType)type{
    
    FUIButton *bt=[FUIButton buttonWithType:UIButtonTypeCustom];
    [bt.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:20.0]];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setFrame:rect];
    bt.buttonColor = [UIColor cloudsColor];
    bt.shadowHeight = 1.0f;
    bt.cornerRadius = 0.0f;
    bt.tag=type;
    [bt setTitleColor:[UIColor peterRiverColor] forState:UIControlStateNormal];
    [bt addTarget:self action:fun forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

#pragma mark -
#pragma mark Bt Methods
-(void)changeDetailVC:(UIButton *)bt{
    
    if (bt.tag==DahonModel) {
        DahonValuationViewController *vc=[[DahonValuationViewController alloc] init];
        vc.comInfo=self.comInfo;
        [self setDetailVC:vc];
        SAFE_RELEASE(vc);
    } else if(bt.tag==DragabelModel){
        
    } else if(bt.tag==FinancalModel){
        FinancalModelContainerViewController *vc=[[FinancalModelContainerViewController alloc] init];
        vc.comInfo=self.comInfo;
        [self setDetailVC:vc];
        SAFE_RELEASE(vc);
    } else if(bt.tag==MyProAndLossTable){
        //controllerName=@"TestViewController";
    }
    
}

-(void)setDetailVC:(UIViewController *)detailViewController{
    
    if (self.detailViewController) {
        [self.detailViewController removeFromParentViewController];
        [self.detailViewController.view removeFromSuperview];
        self.detailViewController=nil;
    }
 
    self.detailViewController=detailViewController;
    self.detailViewController.view.frame=CGRectMake(10,150,1004,608);

    [self addChildViewController:self.detailViewController];
    [self.view addSubview:self.detailViewController.view];
    
}

-(void)backToRoot:(UIBarButtonItem *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
