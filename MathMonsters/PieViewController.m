//
//  ViewController.m
//  Statements
//
//  Created by Moncter8 on 13-5-30.
//  Copyright (c) 2013年 Moncter8. All rights reserved.
//

#import "PieViewController.h"
#import "PieChartView.h"
#import "ComContainerViewController.h"

#define PIE_HEIGHT 420

#define PIE_X 20
#define PIE_Y 60

@interface PieViewController ()

@property (nonatomic,retain) UILabel *selLabel;

@end

@implementation PieViewController

- (id)initWithData:(NSDictionary *)dic comInfo:(id)comInfo
{
    self = [super init];
    if (self) {
        self.comInfo=comInfo;
        self.valueIncomeDic=dic;
        self.valueArray=[NSMutableArray arrayWithArray:[self.valueIncomeDic allKeys]];
        NSArray *temp=[NSArray arrayWithObjects:
                       [Utiles colorWithHexString:@"#ffa42f"],
                       [Utiles colorWithHexString:@"#42e069"],
                       [Utiles colorWithHexString:@"#3ec4df"],
                       [Utiles colorWithHexString:@"#ff1a49"],
                       [Utiles colorWithHexString:@"#5a86d5"],
                       [Utiles colorWithHexString:@"#feffa3"],
                       [Utiles colorWithHexString:@"#bf8fec"],
                       [Utiles colorWithHexString:@"#0c3707"],
                       nil];
        self.defaultColorArray=temp;
        NSMutableArray *temp2=[[[NSMutableArray alloc] init] autorelease];
        self.colorArray=temp2;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for(int n=0;n<[self.valueArray count];n++){
        [self.colorArray addObject:[self.defaultColorArray objectAtIndex:n]];
    }

    CGRect pieFrame = CGRectMake(PIE_X,PIE_Y, PIE_HEIGHT, PIE_HEIGHT);
    
    UIView *tv=[[[UIView alloc]initWithFrame:pieFrame] autorelease];
    self.pieContainer = tv;
    NSMutableArray *values=[[[NSMutableArray alloc] init] autorelease];
    for(NSNumber *number in self.valueArray){
        [values addObject:[NSNumber numberWithLongLong:[number longLongValue]>>4]];
    }

    PieChartView *pv=[[[PieChartView alloc] initWithFrame:self.pieContainer.bounds
                                                withValue:values
                                                withColor:self.colorArray] autorelease];
    self.pieChartView = pv;
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView setAmountText:@""];
    [self.view addSubview:self.pieContainer];
    
    [self.pieChartView setTitleText:@"主营收入"];
    long sum = 0;
    for(id obj in self.valueArray){
        sum+=[obj longValue];
    }
    
    NSNumberFormatter * formatter   = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setPositiveFormat:@"#,###"];
    [self.pieChartView setAmountText:[formatter stringFromNumber:[NSNumber numberWithLong:sum]]];
    
    UIImageView *selView = [[UIImageView alloc]init];
    selView.image = [UIImage imageNamed:@"select.png"];
    selView.frame = CGRectMake(100, self.pieContainer.frame.origin.y + self.pieContainer.frame.size.height, selView.image.size.width/2, selView.image.size.height/2);
    [self.view addSubview:selView];
    
    UILabel *label=[[[UILabel alloc]initWithFrame:CGRectMake(0, 24, selView.image.size.width/2, 21)] autorelease];
    self.selLabel = label;
    self.selLabel.backgroundColor = [UIColor clearColor];
    self.selLabel.textAlignment = NSTextAlignmentCenter;
    self.selLabel.font = [UIFont systemFontOfSize:17];
    self.selLabel.textColor = [UIColor whiteColor];
    [selView addSubview:self.selLabel];
    
}


- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    //[self.selLabel setText:[NSString stringWithFormat:@"%@%2.2f",[self.valueIncomeDic objectForKey:[self.valueArray objectAtIndex:index]][@"text"],per*100]];
    [self.selLabel setText:[NSString stringWithFormat:@"%@",[self.valueIncomeDic objectForKey:[self.valueArray objectAtIndex:index]][@"text"]]];
    [self.delegate pieWasChoosen:[self.valueIncomeDic objectForKey:[self.valueArray objectAtIndex:index]][@"text"]];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    ComContainerViewController *comContainerVC=[[[ComContainerViewController alloc] init] autorelease];
    UINavigationController *comNav=[[[UINavigationController alloc] initWithRootViewController:comContainerVC] autorelease];
    comContainerVC.comInfo=self.comInfo;
    [self presentViewController:comNav animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
