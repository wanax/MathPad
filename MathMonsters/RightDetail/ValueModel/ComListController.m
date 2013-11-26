//
//  ComListController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComListController.h"
#import "ComInfoListColumn1.h"
#import "ComInfoListColumn2.h"
#import "ComInfoListColumn3.h"
#import "ComInfoListColumn4.h"
#import "ComIconListViewController.h"

@interface ComListController ()

@end

@implementation ComListController

- (id)initWithType:(MarketType)type iconTableVC:(ComIconListViewController *)iconTableVC
{
    self = [super init];
    if (self) {
        self.marketType=type;
        self.iconTableVC=iconTableVC;
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(addCompanyInfo)
                                                     name: @"ComListDataRefresh"
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(addCompanyInfo)
                                                     name: @"ComListDataAdd"
                                                   object: nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
    [self addCompanyInfo];
}

-(void)initComponents{
    
    UIScrollView *pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,790, 655)];
    pageScroll.contentSize = CGSizeMake(3160,655);
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    pageScroll.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    [pageScroll setShowsHorizontalScrollIndicator:YES];
    
    ComInfoListColumn *list1=[[[ComInfoListColumn1 alloc] init] autorelease];
    list1.view.frame=CGRectMake(0,0,790,800);
    list1.iconTableVC=self.iconTableVC;
    list1.listController=self;
    
    ComInfoListColumn *list2=[[[ComInfoListColumn2 alloc] init] autorelease];
    list2.view.frame=CGRectMake(790,0,790,800);
    list2.iconTableVC=self.iconTableVC;
    list2.listController=self;
    
    ComInfoListColumn *list3=[[[ComInfoListColumn3 alloc] init] autorelease];
    list3.view.frame=CGRectMake(1580,0,790,800);
    list3.iconTableVC=self.iconTableVC;
    list3.listController=self;
    
    ComInfoListColumn *list4=[[[ComInfoListColumn4 alloc] init] autorelease];
    list4.view.frame=CGRectMake(2370,0,790,800);
    list4.iconTableVC=self.iconTableVC;
    list4.listController=self;
    
    self.modelColumnArr=[NSArray arrayWithObjects:list1,list2,list3,list4, nil];
    self.iconTableVC.comTableArr=[NSArray arrayWithObjects:list1,list2,list3,list4, nil];
    
    [pageScroll addSubview:list1.view];
    [pageScroll addSubview:list2.view];
    [pageScroll addSubview:list3.view];
    [pageScroll addSubview:list4.view];
    [self addChildViewController:list1];
    [self addChildViewController:list2];
    [self addChildViewController:list3];
    [self addChildViewController:list4];
    
    [self.view addSubview:pageScroll];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for(ComInfoListColumn *column in self.modelColumnArr){
        column.comTable.contentOffset=self.contentOffset;
    }
}


#pragma mark -
#pragma mark Net Get JSON Data

-(void)addCompanyInfo{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.marketType],@"market",self.updateTime,@"updatetime", nil];
    [Utiles getNetInfoWithPath:@"QueryIpadAllCompany" andParams:params besidesBlock:^(id resObj){
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        if ([Utiles isBlankString:self.updateTime]) {
            [self.comList removeAllObjects];
        }
        for(id obj in self.comList){
            [temp addObject:obj];
        }
        for (id data in resObj) {
            [temp addObject:data];
        }
        self.comList=temp;
        self.updateTime=[[self.comList lastObject][@"info"] objectForKey:@"updatetime"];
        for(ComInfoListColumn *list in self.modelColumnArr){
            list.comList=self.comList;
            [list.comTable reloadData];
        }
        self.iconTableVC.comList=self.comList;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ComListDataLoaded" object:self];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
