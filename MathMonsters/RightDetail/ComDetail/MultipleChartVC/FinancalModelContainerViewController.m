//
//  FinancalModelContainerViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinancalModelContainerViewController.h"
#import "ChartLeftListViewController.h"
#import "FinancalModelRightListViewController.h"

@interface FinancalModelContainerViewController ()

@end

@implementation FinancalModelContainerViewController

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
    
    UIWebView *web = [[[UIWebView alloc] init] autorelease];
    self.webView=web;
    self.webView.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    
    ChartLeftListViewController *tLeft=[[[ChartLeftListViewController alloc] init] autorelease];
    tLeft.view.frame=CGRectMake(0,0,100,1024);
    self.leftListVC=tLeft;
    [self.view addSubview:self.leftListVC.view];
    [self addChildViewController:self.leftListVC];

}

#pragma mark -
#pragma mark Web Didfinished CallBack
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[self.comInfo objectForKey:@"stockcode"],@"stockCode", nil];
    [Utiles getNetInfoWithPath:@"CompanyModel" andParams:params besidesBlock:^(id resObj){

        self.jsonForChart=[[resObj JSONString] stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        //获取金融模型种类
        id transObj=[self getObjectDataFromJsFun:@"initFinancialData" byData:self.jsonForChart];
        self.leftListVC.transData=transObj;
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id key in transObj){
            [temp addObject:key];
        }
        self.leftListVC.sectionKeys=temp;
        self.leftListVC.sectionDic=@{@"listRatio":@"财务比例",@"listChart":@"财务图表",@"listOther":@"其它指标"};
        [self.leftListVC.expansionTableView reloadData];
        
        
        FinancalModelRightListViewController *tRight=[[[FinancalModelRightListViewController alloc] initWithClassDic:transObj comInfo:self.comInfo jsonData:self.jsonForChart] autorelease];
        tRight.view.frame=CGRectMake(340,0,600,1100);
        self.delegate=tRight;
        self.leftListVC.delegate=tRight;
        self.rightListVC=tRight;
        [self.view addSubview:self.rightListVC.view];
        [self addChildViewController:self.rightListVC];
        [self.delegate rightListClassChanged];
        
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
