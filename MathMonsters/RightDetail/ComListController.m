//
//  ComListController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComListController.h"
#import "ComInfoListViewController.h"
#import "ComIconListViewController.h"

@interface ComListController ()

@end

@implementation ComListController

- (id)initWithType:(MarketType)type iconList:(ComIconListViewController *)iconList
{
    self = [super init];
    if (self) {
        self.marketType=type;
        self.iconList=iconList;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
}

-initComponents{
    
    UIScrollView *pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,894, 655)];
    pageScroll.contentSize = CGSizeMake(2592,655);
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    pageScroll.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    [pageScroll setShowsHorizontalScrollIndicator:YES];
    
    ComInfoListViewController *list1=[[[ComInfoListViewController alloc] initWithMarkType:self.marketType] autorelease];
    list1.view.frame=CGRectMake(0,0,894,800);
    self.iconList.comInfoList=list1;
    
    ComInfoListViewController *list2=[[[ComInfoListViewController alloc] initWithMarkType:self.marketType] autorelease];
    list2.view.frame=CGRectMake(894,0,894,800);
    
    ComInfoListViewController *list3=[[[ComInfoListViewController alloc] initWithMarkType:self.marketType] autorelease];
    list3.view.frame=CGRectMake(1688,0,894,800);
    
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
