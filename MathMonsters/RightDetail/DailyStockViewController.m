//
//  DailyStockViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DailyStockViewController.h"
#import "PieChartView.h"
#import "PieViewController.h"
#import "DailyStockIndicator.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DailyStockViewController ()

@end

@implementation DailyStockViewController

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
    self.view.backgroundColor=[UIColor blackColor];
 
    [self initComponents];
    [self getDailyStockNews];
    
}

-(void)initComponents{
    
    UIImageView *backImgView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dailyBackImg"]] autorelease];
    backImgView.frame=CGRectMake(0,0,924,716);
    [self.view addSubview:backImgView];
    
    self.indicator=[[[DailyStockIndicator alloc] initWithFrame:CGRectMake(0,0, 924, 60)] autorelease];
    [self.view addSubview:self.indicator];
    
    [self addPieView];
}

-(void)addPieView{
    PieViewController *vc=[[PieViewController alloc] init];
    vc.view.backgroundColor=[UIColor clearColor];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

-(void)getDailyStockNews{
    [Utiles getNetInfoWithPath:@"DailyStock" andParams:nil besidesBlock:^(id obj){
        
        self.imageUrl=[NSString stringWithFormat:@"%@",[obj objectForKey:@"imageurl"]];
        [self.indicator.comIconView setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"stockcode"],@"stockcode", nil];
        [Utiles getNetInfoWithPath:@"QueryCompany" andParams:params besidesBlock:^(id resObj){
            
            NSNumber *marketPrice=[resObj objectForKey:@"marketprice"];
            NSNumber *ggPrice=[resObj objectForKey:@"googuuprice"];
            float outLook=([ggPrice floatValue]-[marketPrice floatValue])/[marketPrice floatValue];
            if (outLook>=0) {
                [self.indicator.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#89131E"]];
            }
            [self.indicator.outLookLabel setText:[NSString stringWithFormat:@"%.2f%%",outLook*100]];
            
            [self.indicator.comNameLabel setText:[NSString stringWithFormat:@"%@\n(%@.%@)",[obj objectForKey:@"companyname"],[obj objectForKey:@"stockcode"],[obj objectForKey:@"market"]]];
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"%@",error.localizedDescription);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}



- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
