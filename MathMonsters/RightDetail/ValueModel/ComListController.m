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
                                                 selector: @selector(comListDataLoaded)
                                                     name: @"addCompanyInfo"
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(comListDataAdd)
                                                     name: @"addCompanyInfo"
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
    pageScroll.contentSize = CGSizeMake(2370,655);
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    pageScroll.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    [pageScroll setShowsHorizontalScrollIndicator:YES];
    
    ComInfoListColumn1 *list1=[[[ComInfoListColumn1 alloc] init] autorelease];
    list1.view.frame=CGRectMake(0,0,790,800);
    list1.iconTableVC=self.iconTableVC;
    
    ComInfoListColumn2 *list2=[[[ComInfoListColumn2 alloc] init] autorelease];
    list2.view.frame=CGRectMake(790,0,790,800);
    list2.iconTableVC=self.iconTableVC;
    
    ComInfoListColumn3 *list3=[[[ComInfoListColumn3 alloc] init] autorelease];
    list3.view.frame=CGRectMake(1580,0,790,800);
    list3.iconTableVC=self.iconTableVC;
    
    self.modelColumnArr=[NSArray arrayWithObjects:list1,list2,list3, nil];
    self.iconTableVC.comTableArr=[NSArray arrayWithObjects:list1,list2,list3, nil];
    
    [pageScroll addSubview:list1.view];
    [pageScroll addSubview:list2.view];
    [pageScroll addSubview:list3.view];
    [self addChildViewController:list1];
    [self addChildViewController:list2];
    [self addChildViewController:list3];
    
    [self.view addSubview:pageScroll];
    
}

#pragma mark -
#pragma mark Net Get JSON Data

-(void)addCompanyInfo{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.marketType],@"market",self.updateTime,@"updatetime", nil];
    [Utiles getNetInfoWithPath:@"QueryIpadAllCompany" andParams:params besidesBlock:^(id resObj){
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in self.comList){
            [temp addObject:obj];
        }
        for (id data in resObj) {
            [temp addObject:data];
        }
        self.comList=temp;
        self.updateTime=[[self.comList lastObject] objectForKey:@"updatetime"];
        
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
