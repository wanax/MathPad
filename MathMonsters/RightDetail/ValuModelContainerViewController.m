//
//  ValuModelContainerViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValuModelContainerViewController.h"
#import "ComIconListViewController.h"
#import "ComListController.h"


@interface ValuModelContainerViewController ()

@end

@implementation ValuModelContainerViewController

- (id)initWithType:(MarketType)type
{
    self = [super init];
    if (self) {
        self.marketType=type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
}

-(void)initComponents{
    
    ComIconListViewController *iconList=[[[ComIconListViewController alloc] initWithMarkType:self.marketType] autorelease];
    iconList.view.frame=CGRectMake(0,0,130,1000);
    [self.view addSubview:iconList.view];
    [self addChildViewController:iconList];
    
    ComListController *controller=[[[ComListController alloc] initWithType:self.marketType iconList:iconList] autorelease];
    controller.view.frame=CGRectMake(130,0,894,1000);
    [self.view addSubview:controller.view];
    [self addChildViewController:controller];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end