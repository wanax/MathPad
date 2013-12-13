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
    
    NSDictionary *range = [self getProLossTableYearRange:classArr];
    int begin = [range[@"min"] integerValue];
    int gap = ceil(([range[@"max"] integerValue] - begin + 1)/3);

    MyProLossListViewController *list1=[[[MyProLossListViewController alloc] initWithClassArr:classArr andRangDic:@{@"begin":@(begin),@"end":@(begin+gap),@"count":@(gap)}] autorelease];
    list1.view.frame=CGRectMake(0,0,1024,768);
    list1.delegate=self;
    
    MyProLossListViewController *list2=[[[MyProLossListViewController alloc] initWithClassArr:classArr andRangDic:@{@"begin":@(begin+gap+1),@"end":@(begin+2*gap+1),@"count":@(gap)}] autorelease];
    list2.view.frame=CGRectMake(1024,0,1024,768);
    list2.delegate=self;
    
    MyProLossListViewController *list3=[[[MyProLossListViewController alloc] initWithClassArr:classArr andRangDic:@{@"begin":@(begin+2*gap+2),@"end":range[@"max"],@"count":@([range[@"max"] integerValue]-begin-2*gap-1)}] autorelease];
    list3.view.frame=CGRectMake(2048,0,1024,768);
    list3.delegate=self;
    
    [pageScroll addSubview:list1.view];
    [pageScroll addSubview:list2.view];
    [pageScroll addSubview:list3.view];
    [self addChildViewController:list1];
    [self addChildViewController:list2];
    [self addChildViewController:list3];

    self.proLossLists=[NSArray arrayWithObjects:list1,list2,list3, nil];
    [self.view addSubview:pageScroll];
    
}

//确定损益表显示年份范围
-(NSDictionary *)getProLossTableYearRange:(NSArray *)classArr{
    
    int yearMin = [classArr[0][@"array"][0][@"y"] integerValue];
    int yearMax = yearMin;
    
    for (id classObj in classArr) {
        for (id obj in classObj[@"array"]) {
            int y = [obj[@"y"] integerValue];
            if (y > yearMax) {
                yearMax = y;
            } else if (y < yearMin && y != 0){
                yearMin = y;
            }
        }
    }
    NSDictionary *range = @{@"max":@(yearMax),@"min":@(yearMin)};
    return range;
}

#pragma mark -
#pragma MyProLossList Methods Delegate

-(void)theTableIsScroll:(CGPoint)contentOffset{
    for(MyProLossListViewController *list in self.proLossLists){
        list.proLossTable.contentOffset=contentOffset;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
