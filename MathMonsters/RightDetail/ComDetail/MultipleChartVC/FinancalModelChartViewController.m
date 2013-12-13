//
//  FinancalModelChartViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//


#import "FinancalModelChartViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <AddressBook/AddressBook.h>
#import "DrawChartTool.h"
#import "ChartLeftListViewController.h"

#define HostViewHeight 270.0

@interface FinancalModelChartViewController ()

@end

@implementation FinancalModelChartViewController

static NSString * BAR_IDENTIFIER =@"bar_identifier";



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.colorArr=[NSArray arrayWithObjects:@"e92058",@"b700b7",@"216dcb",@"13bbca",@"65d223",@"f09c32",@"f15a38",nil];
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        self.points=temp;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}
-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIWebView *web=[[[UIWebView alloc] init] autorelease];
    self.webView=web;
    self.webView.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];

    [self initBarChart];
}


-(void)initBarChart{

    CPTXYGraph *tempGraph=[[[CPTXYGraph alloc] initWithFrame:CGRectZero] autorelease];
    self.graph=tempGraph;
    self.graph.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#FCFADD" andAlpha:1.0]];
    CPTGraphHostingView *tempView=[[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(10,10,680,HostViewHeight)] autorelease];
    self.hostView=tempView;
    [self.view addSubview:self.hostView];
    [self.hostView setHostedGraph : self.graph ];
    self.hostView.collapsesLayers = YES;
    
    self.graph . paddingLeft = 0.0f ;
    self.graph . paddingRight = 0.0f ;
    self.graph . paddingTop = 0 ;
    self.graph . paddingBottom = 0 ;
    
    //绘制图形空间
    self.plotSpace=(CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    DrawXYAxisWithoutYAxis;
    [self initBarPlot];
}

-(id)getObjectDataFromJsFun:(NSString *)funName byData:(NSString *)data{
    NSString *arg=[[NSString alloc] initWithFormat:@"%@(\"%@\")",funName,data];
    NSString *re=[self.webView stringByEvaluatingJavaScriptFromString:arg];
    re=[re stringByReplacingOccurrencesOfString:@",]" withString:@"]"];
    SAFE_RELEASE(arg);
    return [re objectFromJSONString];
}

#pragma mark -
#pragma mark ModelClass Methods Delegate

-(void)modelClassChanged:(NSString *)driverId{
    
    id temp=[self getObjectDataFromJsFun:@"returnChartData" byData:driverId];
    NSMutableArray *tempHisPoints=[[NSMutableArray alloc] init];
    for(id obj in [temp objectForKey:@"array"]){
        if([[obj objectForKey:@"h"] boolValue]){
            [tempHisPoints addObject:obj];
        }
    }
    self.points=tempHisPoints;
    self.trueUnit=[temp objectForKey:@"unit"];
    NSArray *sort=[Utiles arrSort:self.points];
    self.yAxisUnit=[Utiles getUnitFromData:[[[sort lastObject] objectForKey:@"v"] stringValue] andUnit:self.trueUnit];
    self.graph.title=[NSString stringWithFormat:@"%@:%@(单位:%@)",self.comInfo[@"companyname"],[temp objectForKey:@"title"],self.yAxisUnit];
    [self setXYAxis];
    self.barPlot.baseValue=CPTDecimalFromFloat(XORTHOGONALCOORDINATE);
    [self.graph reloadData];
    SAFE_RELEASE(tempHisPoints);
    
}

#pragma mark -
#pragma mark Web Didfinished CallBack
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //获取金融模型种类
    id transObj=[self getObjectDataFromJsFun:@"initFinancialData" byData:self.jsonForChart];
    if ([transObj count]>0) {
        [self modelClassChanged:self.driverId];
        self.barPlot.baseValue=CPTDecimalFromFloat(XORTHOGONALCOORDINATE);
    }
}


#pragma mark -
#pragma mark Bar Data Source Delegate

// 添加数据标签
-( CPTLayer *)dataLabelForPlot:( CPTPlot *)plot recordIndex:( NSUInteger )index
{
    static CPTMutableTextStyle *whiteText = nil ;
    if ( !whiteText ) {
        whiteText = [[ CPTMutableTextStyle alloc ] init ];
        whiteText.color=[CPTColor blackColor];
        whiteText.fontSize=12.0;
        whiteText.fontName=@"Heiti SC";
    }
    
    CPTTextLayer *newLayer = nil ;
    NSString *numberString =nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if([self.trueUnit isEqualToString:@"%"]){
        [formatter setPositiveFormat:@"0.0;0.0;-0.0"];
        numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:[[[self.points objectAtIndex:index] objectForKey:@"v"] floatValue]*100]];
    }else{
        numberString=[[[self.points objectAtIndex:index] objectForKey:@"v"] stringValue];
        numberString=[Utiles unitConversionData:numberString andUnit:self.yAxisUnit trueUnit:self.trueUnit];
    }
    newLayer=[[CPTTextLayer alloc] initWithText:numberString style:whiteText];
    SAFE_RELEASE(formatter);
    return [newLayer autorelease];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return [self.points count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger) index{
    
    NSNumber *num=nil;
    
    if([(NSString *)plot.identifier isEqualToString:BAR_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        
        if([key isEqualToString:@"x"]){
            num=[NSNumber numberWithInt:[[[self.points objectAtIndex:index] objectForKey:@"y"] intValue]];
        }else if([key isEqualToString:@"y"]){
            num=[NSNumber numberWithFloat:[[[self.points objectAtIndex:index] objectForKey:@"v"] floatValue]];
        }
        
    }
    
    return num;
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    if(axis.coordinate==CPTCoordinateX){
        
        NSNumberFormatter * formatter   = (NSNumberFormatter *)axis.labelFormatter;
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setPositiveFormat:@"##"];
        NSMutableSet * newLabels        = [NSMutableSet set];

        for (NSDecimalNumber * tickLocation in locations) {

            CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
            newStyle.fontSize=14.0;
            newStyle.fontName=@"Heiti SC";
            newStyle.color=[CPTColor blackColor];

            NSString * labelString      = [formatter stringForObjectValue:tickLocation];
            labelString=[Utiles yearFilled:labelString];
            CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString style:newStyle];
            CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
            newLabel.tickLocation       = tickLocation.decimalValue;
            newLabel.offset             = 13.0;
            newLabel.rotation           = 0;
            [newLabels addObject:newLabel];
            SAFE_RELEASE(newLabel);
            SAFE_RELEASE(newLabelLayer);
        }
        
        axis.axisLabels = newLabels;
    }
    return NO;
}

-(void)initBarPlot{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit=0.0f;
    lineStyle.lineWidth=0.0f;
    lineStyle.lineColor=[CPTColor colorWithComponentRed:87/255.0 green:168/255.0 blue:9/255.0 alpha:1.0];
    self.barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:134/255.0 green:171/255.0 blue:125/255.0 alpha:1.0] horizontalBars:NO];
    self.barPlot. dataSource = self ;
    self.barPlot.delegate=self;
    self.barPlot.lineStyle=lineStyle;
    self.barPlot.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:[self.colorArr objectAtIndex:arc4random()%7] andAlpha:0.6]];
    // 图形向右偏移： 0.25
    self.barPlot.barOffset = CPTDecimalFromFloat(0.0f) ;

    self.barPlot.barCornerRadius=3.0;
    self.barPlot.barWidth=CPTDecimalFromFloat(1.0f);
    self.barPlot.barWidthScale=0.5f;
    self.barPlot.labelOffset=0;
    self.barPlot.identifier = BAR_IDENTIFIER;
    self.barPlot.opacity=0.0f;

    // 添加图形到绘图空间
    [self.graph addPlot :self.barPlot toPlotSpace :self.plotSpace];
}

-(void)setXYAxis{
    NSMutableArray *xTmp=[[NSMutableArray alloc] init];
    NSMutableArray *yTmp=[[NSMutableArray alloc] init];
    for(id obj in self.points){
        [xTmp addObject:[obj objectForKey:@"y"]];
        [yTmp addObject:[obj objectForKey:@"v"]];
    }
    NSDictionary *xyDic=[DrawChartTool getXYAxisRangeFromxArr:xTmp andyArr:yTmp fromWhere:FinancalModel screenHeight:HostViewHeight];
    XRANGEBEGIN=[[xyDic objectForKey:@"xBegin"] floatValue];
    XRANGELENGTH=[[xyDic objectForKey:@"xLength"] floatValue];
    XORTHOGONALCOORDINATE=[[xyDic objectForKey:@"xOrigin"] floatValue];
    XINTERVALLENGTH=[[xyDic objectForKey:@"xInterval"] floatValue];
    YRANGEBEGIN=[[xyDic objectForKey:@"yBegin"] floatValue];
    YRANGELENGTH=[[xyDic objectForKey:@"yLength"] floatValue];
    YORTHOGONALCOORDINATE=[[xyDic objectForKey:@"yOrigin"] floatValue];
    YINTERVALLENGTH=[[xyDic objectForKey:@"yInterval"] floatValue];
    DrawXYAxisWithoutYAxis;
    SAFE_RELEASE(xTmp);
    SAFE_RELEASE(yTmp);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return NO;
}









@end