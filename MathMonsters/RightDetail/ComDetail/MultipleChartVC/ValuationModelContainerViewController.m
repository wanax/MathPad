//
//  ValuationModelContainerViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValuationModelContainerViewController.h"
#import "ChartLeftListViewController.h"
#import "ValueModelChartViewController.h"

@interface ValuationModelContainerViewController ()

@end

@implementation ValuationModelContainerViewController

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
	[self initComponents];
}


-(void)initComponents{
    
    UIWebView *tWeb=[[[UIWebView alloc] init] autorelease];
    tWeb.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"html"];
    [tWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    self.webView=tWeb;

    ChartLeftListViewController *tLeft=[[[ChartLeftListViewController alloc] init] autorelease];
    tLeft.view.frame=CGRectMake(0,0,100,1024);
    self.leftListVC=tLeft;
    [self.view addSubview:self.leftListVC.view];
    [self addChildViewController:self.leftListVC];
    
    ValueModelChartViewController *tRight=[[[ValueModelChartViewController alloc] init] autorelease];
    tRight.view.frame=CGRectMake(300,0,600,1100);
    tRight.comInfo=self.comInfo;
    tRight.sourceType=self.sourceType;
    
    self.leftListVC.delegate=tRight;
    self.delegate=tRight;
    self.rightListVC=tRight;
    self.rightListVC.delegate=self.leftListVC;
    [self.view addSubview:self.rightListVC.view];
    [self addChildViewController:self.rightListVC];
 
}

#pragma mark -
#pragma mark Web Didfinished CallBack
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params=@{@"stockCode": self.comInfo[@"stockcode"]};
    [Utiles getNetInfoWithPath:@"CompanyModel" andParams:params besidesBlock:^(id resObj){
        
        self.rightListVC.jsonForChart=resObj;
        [self.delegate rightVCDataHasBeenLoaded];
   
        self.jsonForChart=[resObj JSONString];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        id resTmp=[Utiles getObjectDataFromJsFun:self.webView funName:@"initData" byData:self.jsonForChart shouldTrans:YES];
        id transObj=resTmp;
        self.leftListVC.transData=transObj;
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id key in transObj){
            [temp addObject:key];
        }
        self.leftListVC.sectionKeys=temp;
        self.leftListVC.sectionDic=@{@"listMain":@"主营收入",@"listFee":@"运营费用",@"listCap":@"运营资本",@"listWacc":@"折现率"};
        [self.leftListVC.expansionTableView reloadData];

        NSLog(@"getNetInfo:%d",[transObj count]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(id)getObjectDataFromJsFun:(NSString *)funName byData:(NSString *)data{
    NSString *arg=[[NSString alloc] initWithFormat:@"%@(\"%@\")",funName,data];
    NSString *re=[self.webView stringByEvaluatingJavaScriptFromString:arg];
    re=[re stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
    SAFE_RELEASE(arg);
    return [re objectFromJSONString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
