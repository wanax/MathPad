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
#import "TipView.h"


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
    
    TipView *t=[[[TipView alloc] initWithFrame:CGRectMake(0,0,924,SCREEN_HEIGHT)] autorelease];
    self.tip=t;
    
    UITapGestureRecognizer *tap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipViewIsClicked:)] autorelease];
    [self.tip addGestureRecognizer:tap];
    
    [self.view addSubview:self.tip];
    
}

-(void)tipViewIsClicked:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.6f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.tip.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.tip removeFromSuperview];
                     }];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.tip removeFromSuperview];
}

-(void)initComponents{
    
    ComIconListViewController *iconTableVC=[[[ComIconListViewController alloc] initWithMarkType:self.marketType] autorelease];
    iconTableVC.view.frame=CGRectMake(0,0,130,1000);
    [self.view addSubview:iconTableVC.view];
    [self addChildViewController:iconTableVC];
    
    ComListController *controller=[[[ComListController alloc] initWithType:self.marketType iconTableVC:iconTableVC] autorelease];
    controller.view.frame=CGRectMake(130,0,894,1000);
    [self.view addSubview:controller.view];
    [self addChildViewController:controller];
    
    iconTableVC.comListController=controller;
}

- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
