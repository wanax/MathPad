//
//  MyGooGuuViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "MyGooGuuViewController.h"
#import "ClientRelationStockListViewController.h"
#import "ClientCalendarViewController.h"
#import "MHTabBarController.h"


@interface MyGooGuuViewController ()
@end

@implementation MyGooGuuViewController

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
	[self.view setBackgroundColor:[UIColor midnightBlueColor]];
    [self initComponents];
}

-(void)initComponents{
    
    ClientRelationStockListViewController *t=[[[ClientRelationStockListViewController alloc] init] autorelease];
    t.clientType=MyConcernedType;
    self.concernedListViewController=t;
    
    ClientRelationStockListViewController *tt=[[[ClientRelationStockListViewController alloc] init] autorelease];
    tt.clientType=MySavedType;
    self.savedListViewControler=tt;
    
    ClientCalendarViewController *c=[[[ClientCalendarViewController alloc] init] autorelease];
    self.calendarViewController=c;

    self.concernedListViewController.title=@"投资组合";
    self.savedListViewControler.title=@"我的模型";
    self.calendarViewController.title=@"投资日历";

	NSArray *viewControllers = [NSArray arrayWithObjects:self.concernedListViewController, self.savedListViewControler,self.calendarViewController, nil];
    MHTabBarController *h=[[[MHTabBarController alloc] init] autorelease];
	h.viewControllers = viewControllers;
    self.tabBarController=h;
    [self addChildViewController:self.tabBarController];
    [self.view addSubview:self.tabBarController.view];
    
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
