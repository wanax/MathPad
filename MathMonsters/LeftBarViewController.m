//
//  LeftBarViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "LeftBarViewController.h"

@interface LeftBarViewController ()

@end

@implementation LeftBarViewController


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

	self.dailyStockBt=[self addBt:@"dailyStockBt" rect:CGRectMake(0,0,100,100) tag:DailyStockLeftBar];
    self.newReportBt=[self addBt:@"newReportBt" rect:CGRectMake(0,100,100,100) tag:NewReportLeftBar];
    self.valuModelBt=[self addBt:@"valuModelBt" rect:CGRectMake(0,200,100,100) tag:ValuModelLeftBar];
    self.myGooguuBt=[self addBt:@"myGooguuBt" rect:CGRectMake(0,300,100,100) tag:MyGooGuuLeftBar];
    self.graphExchangeBt=[self addBt:@"graphExchangeBt" rect:CGRectMake(0,400,100,100) tag:GraphExchangeLeftBar];
    self.financeToolBt=[self addBt:@"financeToolBt" rect:CGRectMake(0,500,100,100) tag:FinanceToolLeftBar];
    self.settingBt=[self addBt:@"settingBt" rect:CGRectMake(0,600,100,100) tag:SettingLeftBar];
    
    self.btArr=[NSArray arrayWithObjects:self.dailyStockBt,self.newReportBt,self.valuModelBt,self.myGooguuBt,self.graphExchangeBt,self.financeToolBt,self.settingBt, nil];
}

-(UIButton *)addBt:(NSString *)name rect:(CGRect)rect tag:(LfteBarType)tag{
    
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:rect];
    [bt setTag:tag];
    [bt setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [bt setBackgroundImage:[UIImage imageNamed:[name stringByAppendingFormat:@"Se"]] forState:UIControlStateDisabled];
    [bt addTarget:self action:@selector(barBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    return bt;
}

-(void)barBtClicked:(UIButton *)bt{
    
    int tag=bt.tag;
    
    if (tag==DailyStockLeftBar) {        
        [self.delegate barChanged:@"DailyStockViewController"];
    }else if(tag==NewReportLeftBar) {     
        [self.delegate barChanged:@"NewReportViewController"];        
    }else if(tag==ValuModelLeftBar) {
        [self.delegate barChanged:@"ValuModelViewController"];        
    }else if(tag==MyGooGuuLeftBar) {        
        [self.delegate barChanged:@"MyGooGuuViewController"];        
    }else if(tag==GraphExchangeLeftBar) {        
        [self.delegate barChanged:@"GraphExchangeViewController"];        
    }else if(tag==FinanceToolLeftBar) {
        [self.delegate barChanged:@"FinanceToolViewController"];        
    }else if(tag==SettingLeftBar) {        
        [self.delegate barChanged:@"SettingViewController"];        
    }
    [bt setEnabled:NO];
    [self deselectBt:tag];

}

-(void)deselectBt:(LfteBarType)tag{    
    for (UIButton *bt in self.btArr) {
        if(bt.tag!=tag){
            [bt setSelected:NO];
            [bt setEnabled:YES];
        }
    }    
}















- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
