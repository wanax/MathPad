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
#import "DailyRightListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ComContainerViewController.h"

@interface DailyStockViewController ()

@end

@implementation DailyStockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        self.controllers=temp;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self getDailyStockNews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstLaunch=YES;
    self.view.backgroundColor=[Utiles colorWithHexString:@"#FDFBE4"];
    [self initComponents];
}

-(void)initComponents{
    
    UIImageView *backImgView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dailyBackImg"]] autorelease];
    backImgView.frame=CGRectMake(0,0,924,716);
    [self.view addSubview:backImgView];
    
    self.indicator=[[[DailyStockIndicator alloc] initWithFrame:CGRectMake(0,0, 924, 90)] autorelease];
    [self.view addSubview:self.indicator];
    
}

-(void)comNameBtClicked:(UIButton *)bt{
    ComContainerViewController *comContainerVC=[[[ComContainerViewController alloc] init] autorelease];
    UINavigationController *comNav=[[[UINavigationController alloc] initWithRootViewController:comContainerVC] autorelease];
    comContainerVC.comInfo=self.companyInfo;
    [self presentViewController:comNav animated:YES completion:nil];
}

-(void)addPieView:(NSDictionary *)valueDic driverIds:(NSArray *)ids classWithChildId:(NSDictionary *)dic{
    
    for (int n=[self.controllers count];n>0;n--) {
        UIViewController *controller=self.controllers[n-1];
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    PieViewController *vc=[[[PieViewController alloc] initWithData:valueDic comInfo:self.companyInfo] autorelease];
    vc.view.frame=CGRectMake(0,90,450,670);
    vc.view.backgroundColor=[Utiles colorWithHexString:@"#FDFBE4"];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    DailyRightListViewController *rightList=[[[DailyRightListViewController alloc] initWithValueIncomeDic:valueDic driverIds:ids jsonData:self.jsonData comInfo:self.companyInfo] autorelease];
    rightList.view.backgroundColor=[UIColor clearColor];
    rightList.view.frame=CGRectMake(450,90,500,1000);
    rightList.classToChildIds=dic;
    vc.delegate=rightList;
    [self addChildViewController:rightList];
    [self.view addSubview:rightList.view];

    [self.controllers addObject:vc];
    [self.controllers addObject:rightList];
}

-(void)getDailyStockNews{
    [Utiles getNetInfoWithPath:@"DailyStock" andParams:nil besidesBlock:^(id obj){
        
        self.imageUrl=[NSString stringWithFormat:@"%@",[obj objectForKey:@"imageurl"]];
        self.companyInfo=obj;
        [self.indicator.comIconView setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
        [self.indicator.googuuPriLabel setText:[NSString stringWithFormat:@"%.2f",[obj[@"googuuprice"] floatValue]]];
        [self.indicator.marketPriLabel setText:[NSString stringWithFormat:@"%.2f",[obj[@"marketprice"] floatValue]]];
        [self.indicator.comNameButton setTitle:[NSString stringWithFormat:@"%@\n(%@.%@)",[obj objectForKey:@"companyname"],[obj objectForKey:@"stockcode"],[obj objectForKey:@"marketname"]] forState:UIControlStateNormal];
        [self.indicator.comNameButton addTarget:self action:@selector(comNameBtClicked:) forControlEvents:UIControlEventTouchUpInside];
  
        NSNumber *marketPrice=[obj objectForKey:@"marketprice"];
        NSNumber *ggPrice=[obj objectForKey:@"googuuprice"];
        float outLook=([ggPrice floatValue]-[marketPrice floatValue])/[marketPrice floatValue];
        if (outLook>=0) {
            [self.indicator.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#89131E"]];
        }
        [self.indicator.outLookLabel setText:[NSString stringWithFormat:@"%.2f%%",outLook*100]];

        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"stockcode"],@"stockCode", nil];
        [Utiles getNetInfoWithPath:@"CompanyModel" andParams:params besidesBlock:^(id resObj){
            
            self.jsonData=resObj;
            NSArray *childs=resObj[@"model"][@"tree"][@"root"][@"child"];
            self.driverData=resObj[@"model"][@"driver"];

            NSMutableDictionary *valueMainIncomeDic=[[[NSMutableDictionary alloc] init] autorelease];
            for(id obj in childs){
                [valueMainIncomeDic setObject:obj forKey:[self nearestForecastYear:obj[@"identifier"]]];
            }
            NSMutableDictionary *dic=[[[NSMutableDictionary alloc] init] autorelease];
            [self addPieView:valueMainIncomeDic driverIds:[self getGrade2DriverIds:childs divisionData:resObj[@"model"][@"division"] classWithChildId:dic] classWithChildId:dic];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];

    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(NSArray *)getGrade2DriverIds:(NSArray *)childs divisionData:(id)divisionData classWithChildId:(NSMutableDictionary *)classWithChildIdDic{
    
    NSMutableArray *driverIds=[[[NSMutableArray alloc] init] autorelease];
    for(id obj in childs){
        /*for(id driverId in divisionData[obj[@"identifier"]][@"drivers"]){
            [driverIds addObject:driverId];
        }*/
        if([obj[@"child"] count]>0){
            NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
            for(id childObj in obj[@"child"]){
                for(id driverId in divisionData[childObj[@"identifier"]][@"drivers"]){
                    [driverIds addObject:driverId];
                    [temp addObject:driverId];
                }
            }
            [classWithChildIdDic setObject:temp forKey:obj[@"text"]];
        }else{
            NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
            for(id driverId in divisionData[obj[@"identifier"]][@"drivers"]){
                [driverIds addObject:driverId];
                [temp addObject:driverId];
            }
            [classWithChildIdDic setObject:temp forKey:obj[@"text"]];
        }
    }
    return [NSArray arrayWithArray:driverIds];
}

-(NSNumber *)nearestForecastYear:(id)driverId{
    
    NSArray *arr=self.driverData[driverId][@"array"];
    for(id obj in arr){
        if (![obj[@"h"] boolValue]) {
            return [NSNumber numberWithDouble:[obj[@"v"] doubleValue]];
        }
    }
    return [NSNumber numberWithDouble:0.0];
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
}

@end
