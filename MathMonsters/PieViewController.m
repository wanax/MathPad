//
//  ViewController.m
//  Statements
//
//  Created by Moncter8 on 13-5-30.
//  Copyright (c) 2013年 Moncter8. All rights reserved.
//

#import "PieViewController.h"
#import "PieChartView.h"

#define PIE_HEIGHT 350

#define PIE_X 50
#define PIE_Y 200

@interface PieViewController ()
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *valueArray2;
@property (nonatomic,strong) NSMutableArray *colorArray2;
@property (nonatomic,strong) PieChartView *pieChartView;
@property (nonatomic,strong) UIView *pieContainer;
@property (nonatomic)BOOL inOut;
@property (nonatomic,strong) UILabel *selLabel;
@end

@implementation PieViewController

- (void)dealloc
{
    self.valueArray = nil;
    self.colorArray = nil;
    self.valueArray2 = nil;
    self.colorArray2 = nil;
    self.pieContainer = nil;
    self.selLabel = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inOut = YES;
    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:4],
                       nil];
    self.valueArray2 = [[NSMutableArray alloc] initWithObjects:
                        [NSNumber numberWithInt:3],
                        [NSNumber numberWithInt:2],
                        [NSNumber numberWithInt:2],
                        nil];
    
    self.colorArray = [NSMutableArray arrayWithObjects:
                       [Utiles colorWithHexString:@"#ffa42f"],
                       [Utiles colorWithHexString:@"#42e069"],
                       [Utiles colorWithHexString:@"#3ec4df"],
                       [Utiles colorWithHexString:@"#ff1a49"],
                       [Utiles colorWithHexString:@"#5a86d5"],
                       [Utiles colorWithHexString:@"#feffa3"],
                       nil];
    self.colorArray2 = [[NSMutableArray alloc] initWithObjects:
                        [UIColor purpleColor],
                        [UIColor orangeColor],
                        [UIColor magentaColor],
                        nil];
    
    //add shadow img
    CGRect pieFrame = CGRectMake(PIE_X,PIE_Y, PIE_HEIGHT, PIE_HEIGHT);
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc] initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView setAmountText:@"-2456.0"];
    [self.view addSubview:self.pieContainer];

    [self.pieChartView setTitleText:@"支出总计"];
    self.title = @"对账单";
    self.view.backgroundColor = [Utiles colorWithHexString:@"#f3f3f3"];
}


- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    self.selLabel.text = [NSString stringWithFormat:@"%2.2f%@",per*100,@"%"];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.inOut?self.valueArray:self.valueArray2 withColor:self.inOut?self.colorArray:self.colorArray2];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    if (self.inOut) {
        [self.pieChartView setTitleText:@"支出总计"];
        [self.pieChartView setAmountText:@"-2456.0"];
        
    }else{
        [self.pieChartView setTitleText:@"收入总计"];
        [self.pieChartView setAmountText:@"+567.23"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
