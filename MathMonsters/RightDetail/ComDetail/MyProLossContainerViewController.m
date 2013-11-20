//
//  MyProLossContainerViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-19.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "MyProLossContainerViewController.h"
#import "MyProLossListViewController.h"

@interface MyProLossContainerViewController ()

@end

@implementation MyProLossContainerViewController

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
	[self getComJsonData];
}

-(void)getComJsonData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[self.comInfo objectForKey:@"stockcode"],@"stockCode", nil];
    [Utiles getNetInfoWithPath:@"CompanyModel" andParams:params besidesBlock:^(id resObj){
        
        NSArray *pc=resObj[@"model"][@"root"][@"pc"];
        id driverData=resObj[@"model"][@"driver"];
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id driverId in pc){
            if (driverData[driverId]) {
                [temp addObject:driverData[driverId]];
            }
        }
        [self initTableList:temp];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)initTableList:(NSArray *)classArr{
    
    UIScrollView *pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,1024, 768)];
    pageScroll.contentSize = CGSizeMake(3072,708);
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    [pageScroll setShowsHorizontalScrollIndicator:YES];
    

    MyProLossListViewController *list1=[[[MyProLossListViewController alloc] initWithClassArr:classArr andRangDic:@{@"begin":@(0),@"end":@(5),@"count":@(6)}] autorelease];
    list1.view.frame=CGRectMake(0,0,1024,768);
    
    MyProLossListViewController *list2=[[[MyProLossListViewController alloc] initWithClassArr:classArr andRangDic:@{@"begin":@(6),@"end":@(11),@"count":@(6)}] autorelease];
    list2.view.frame=CGRectMake(1024,0,1024,768);
    
    MyProLossListViewController *list3=[[[MyProLossListViewController alloc] initWithClassArr:classArr andRangDic:@{@"begin":@(12),@"end":@(17),@"count":@(6)}] autorelease];
    list3.view.frame=CGRectMake(2048,0,1024,768);
    
    [pageScroll addSubview:list1.view];
    [pageScroll addSubview:list2.view];
    [pageScroll addSubview:list3.view];
    [self addChildViewController:list1];
    [self addChildViewController:list2];
    [self addChildViewController:list3];

    [self.view addSubview:pageScroll];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
