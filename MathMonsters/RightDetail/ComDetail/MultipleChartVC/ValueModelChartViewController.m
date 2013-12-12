//
//  ValueModelChartViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ValueModelChartViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "math.h"
#import <AddressBook/AddressBook.h>
#import "MBProgressHUD.h"
#import "DrawChartTool.h"
#import "UIButton+BGColor.h"
#import <CoreText/CoreText.h>
#import "DiscountRateViewController.h"
#import "UIViewController+MJPopupViewController.h"



@interface ValueModelChartViewController ()

@end

@implementation ValueModelChartViewController

static NSString * FORECAST_DATALINE_IDENTIFIER =@"forecast_dataline_identifier";
static NSString * FORECAST_DEFAULT_DATALINE_IDENTIFIER =@"forecast_default_dataline_identifier";
static NSString * HISTORY_DATALINE_IDENTIFIER =@"history_dataline_identifier";
static NSString * COLUMNAR_DATALINE_IDENTIFIER =@"columnar_dataline_identifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *tFor=[[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *tHis=[[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *tForD=[[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *tStand=[[[NSMutableArray alloc] init] autorelease];
        self.forecastPoints=tFor;
        self.hisPoints=tHis;
        self.forecastDefaultPoints=tForD;
        self.standard=tStand;
    }
    return self;
}

#pragma mark -
#pragma mark General Methods
-(void)addToDriverIds:(NSString *)driverId{
    //NSLog(@"addToDriverIds");
    if(![self.changedDriverIds containsObject:driverId]){
        [self.changedDriverIds addObject:driverId];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self viewDidAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
    if(self.webIsLoaded){
        if(![Utiles isBlankString:self.valuesStr]){
            self.valuesStr=[self.valuesStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            [Utiles getObjectDataFromJsFun:self.webView funName:@"setValues" byData:self.valuesStr shouldTrans:NO];
            [self modelChanged:self.globalDriverId];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidLoad
{
    //NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#F6F1E6"]];
    [self.discountBt setEnabled:NO];
    
    [self initVariable];
    
    UIWebView *tWeb=[[[UIWebView alloc] init] autorelease];
    tWeb.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"c" ofType:@"html"];
    [tWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    self.webView=tWeb;
    
    [self initPlotSpace];
}
-(void)initVariable{
    
    NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
    self.changedDriverIds=temp;
    _inkage=YES;
    _isSaved=YES;
    self.webIsLoaded=NO;

}

-(void)initPlotSpace{

    CPTXYGraph *tGraph=[[[CPTXYGraph alloc] initWithFrame:CGRectZero] autorelease];
    tGraph.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#FCFADD" andAlpha:1.0]];
    CPTGraphHostingView *tHostView=[[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(10,70,700,520) ] autorelease];
    [self.view addSubview:tHostView];
    [tHostView setHostedGraph : tGraph ];
    tGraph . paddingLeft = 0.0f ;
    tGraph . paddingRight = 0.0f ;
    tGraph . paddingTop = 0 ;
    tGraph . paddingBottom = GRAPAHBOTTOMPAD ;
    self.plotSpace=(CPTXYPlotSpace *)tGraph.defaultPlotSpace;
    
    self.graph=tGraph;
    self.hostView=tHostView;
    
    DrawXYAxis;
}

-(void)initChartViewComponents{
    
    DrawChartTool *tool=[[DrawChartTool alloc] init];
    tool.standIn=self;

    self.saveBt=[tool addButtonToView:self.view withTitle:@"保存" Tag:SaveData frame:CGRectMake(480,10,72,45) andFun:@selector(chartAction:) withType:UIButtonTypeRoundedRect andColor:@"#3498DB" textColor:@"#000000" normalBackGroundImg:nil highBackGroundImg:nil];

    self.linkBt=[tool addButtonToView:self.view withTitle:@"点动" Tag:DragChartType frame:CGRectMake(560,10,72,45) andFun:@selector(chartAction:) withType:UIButtonTypeRoundedRect andColor:@"#9B59B6" textColor:@"#000000" normalBackGroundImg:nil highBackGroundImg:nil];
    
    self.resetBt=[tool addButtonToView:self.view withTitle:@"复位" Tag:ResetChart frame:CGRectMake(640,10,72,45) andFun:@selector(chartAction:) withType:UIButtonTypeRoundedRect andColor:@"#3498DB" textColor:@"#000000" normalBackGroundImg:nil highBackGroundImg:nil];

    [tool addLabelToView:self.view withTitle:@"估股估值" Tag:11 frame:CGRectMake(10,0,180,35) fontSize:20.0 color:nil textColor:@"#817a6b" location:NSTextAlignmentLeft];
    [tool addLabelToView:self.view withTitle:[NSString stringWithFormat:@"HK$:%.2f",[self.netComInfo[@"GooguuValuation"] floatValue]] Tag:11 frame:CGRectMake(210,0,120,35) fontSize:20.0 color:nil textColor:@"#e18e14" location:NSTextAlignmentLeft];

    self.myGGpriceLabel=[tool addLabelToView:self.view withTitle:@"我的估值" Tag:11 frame:CGRectMake(10,35,180,35) fontSize:20.0 color:nil textColor:@"#817a6b" location:NSTextAlignmentLeft];
    self.priceLabel=[tool addLabelToView:self.view withTitle:@"" Tag:11 frame:CGRectMake(210,35,120,35) fontSize:20.0 color:nil textColor:@"#e18e14" location:NSTextAlignmentLeft];
    
    if(self.sourceType!=MySavedType){
        [self.myGGpriceLabel setHidden:YES];
        [self.priceLabel setHidden:YES];
    }
    
    [self addScatterChart];
    SAFE_RELEASE(tool);
}

#pragma mark -
#pragma Button Clicked Methods
-(void)chartAction:(UIButton *)bt{
    
    bt.showsTouchWhenHighlighted=YES;
    if(bt.tag==SaveData){
        
        id combinedData=[DrawChartTool changedDataCombinedWebView:self.webView comInfo:self.comInfo ggPrice:self.priceLabel.text dragChartChangedDriverIds:self.changedDriverIds disCountIsChanged:self.disCountIsChanged];
        
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Utiles getUserToken],@"token",@"googuu",@"from",[combinedData JSONString],@"data", nil];
        
        [Utiles postNetInfoWithPath:@"AddModelData" andParams:params besidesBlock:^(id resObj){
            if([resObj[@"status"] isEqual:@"1"]){
                [bt setBackgroundImage:[UIImage imageNamed:@"savedBt"] forState:UIControlStateNormal];
                [bt setEnabled:NO];
                _isSaved=YES;
                [Utiles showToastView:self.view withTitle:nil andContent:resObj[@"msg"] duration:1.5];
            }else if([resObj[@"status"] isEqual:@"2"]){
                [Utiles showToastView:self.view withTitle:nil andContent:resObj[@"msg"] duration:1.5];
            }else{
                [Utiles showToastView:self.view withTitle:nil andContent:@"保存失败" duration:1.5];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"用户未登录" duration:1.5];
        }];
        [self.changedDriverIds removeAllObjects];
        
    }else if(bt.tag==DragChartType){
        if(_inkage){
            [bt setTitle:@"联动" forState:UIControlStateNormal];
            [self addBarChart];
            _inkage=NO;
        }else{
            [bt setTitle:@"点动" forState:UIControlStateNormal];
            [self addScatterChart];
            _inkage=YES;
        }
    }else if(bt.tag==ResetChart){
        [self.forecastPoints removeAllObjects];
        for(id obj in self.forecastDefaultPoints){
            [self.forecastPoints addObject:[obj mutableCopy]];
        }
        [self.forecastPoints removeObjectAtIndex:0];
        [self.hisPoints lastObject][@"v"] = (self.forecastDefaultPoints)[1][@"v"];
        [self addToDriverIds:self.globalDriverId];
        [self setStockPrice];
        [self setXYAxis];
    }else if(bt.tag==BackToSuperView){
        bt.showsTouchWhenHighlighted=YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark WebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.webIsLoaded=YES;
}

#pragma mark -
#pragma mark ValuationContainer Delegate
-(void)rightVCDataHasBeenLoaded{
    
    if (self.webIsLoaded) {
        
        self.netComInfo=self.jsonForChart[@"info"];
        [self initChartViewComponents];
        
        self.jsonForChart=[self.jsonForChart JSONString];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
        self.jsonForChart=[self.jsonForChart stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        id resTmp=[Utiles getObjectDataFromJsFun:self.webView funName:@"initData" byData:self.jsonForChart shouldTrans:YES];

        if(self.globalDriverId==0){
            self.globalDriverId=resTmp[@"listMain"][0][@"id"];
        }
        if(self.sourceType==MySavedType){
            [self adjustChartDataForSaved:self.comInfo[@"stockcode"] andToken:[Utiles getUserToken]];
        }else{
            [self modelChanged:self.globalDriverId];
        }
        if(!self.isAddGesture){
            //手势添加
            UIPanGestureRecognizer *panGr=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPan:)];
            [self.hostView addGestureRecognizer:panGr];
            [panGr release];
            self.isAddGesture=YES;
        }
    }
}

#pragma mark -
#pragma mark ModelClass Methods Delegate
-(void)modelChanged:(NSString *)driverId{
    
    if ([driverId intValue]==DiscountRate) {
        NSString *values=[Utiles getObjectDataFromJsFun:self.webView funName:@"getValues" byData:nil shouldTrans:NO];
        DiscountRateViewController *rateViewController=[[DiscountRateViewController alloc] initWithNibName:@"DiscountRateView" bundle:nil];
        rateViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        rateViewController.comInfo=self.comInfo;
        rateViewController.jsonData=self.jsonForChart;
        rateViewController.valuesStr=values;
        rateViewController.dragChartChangedDriverIds=self.changedDriverIds;
        rateViewController.chartViewController=self;
        rateViewController.sourceType=ChartViewType;
        self.isShowDiscountView=YES;
        [self presentViewController:rateViewController animated:YES completion:nil];
    } else {
        id chartData=[Utiles getObjectDataFromJsFun:self.webView funName:@"returnChartData" byData:driverId shouldTrans:YES];
        self.globalDriverId=driverId;
        
        [self divideData:chartData];
        
        self.trueUnit=chartData[@"unit"];
        NSArray *sort=[Utiles arrSort:self.forecastPoints];
        self.yAxisUnit=[Utiles getUnitFromData:[[[sort lastObject] objectForKey:@"v"] stringValue] andUnit:self.trueUnit];

        self.graph.title=[NSString stringWithFormat:@"%@:%@(单位:%@)",self.comInfo[@"companyname"],chartData[@"title"],self.yAxisUnit];
        [self setXYAxis];
        [self setStockPrice];
    }
    
}


#pragma mark -
#pragma mark General Methods
-(void)divideData:(id)sourceData{
    @try {
        [self.hisPoints removeAllObjects];
        [self.forecastDefaultPoints removeAllObjects];
        [self.forecastPoints removeAllObjects];
        //构造折点数据键值对 key：年份 value：估值 方便后面做临近折点的判断
        NSMutableDictionary *mutableObj=nil;
        for(id obj in sourceData[@"array"]){
            mutableObj=[[NSMutableDictionary alloc] initWithDictionary:obj];
            if([mutableObj[@"h"] boolValue]){
                [self.hisPoints addObject:mutableObj];
            }else{
                [self.forecastDefaultPoints addObject:[[mutableObj mutableCopy] autorelease]];
            }
        }
        for(id obj in sourceData[@"arraynew"]){
            mutableObj=[[NSMutableDictionary alloc] initWithDictionary:obj];
            [self.forecastPoints addObject:mutableObj];
        }
        //历史数据与预测数据线拼接
        [self.forecastDefaultPoints insertObject:[self.hisPoints lastObject] atIndex:0];
        //[self.forecastPoints insertObject:[self.hisPoints lastObject] atIndex:0];
        [self.hisPoints addObject:self.forecastPoints[0]];
        SAFE_RELEASE(mutableObj);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void)adjustChartDataForSaved:(NSString *)stockCode andToken:(NSString*)token{

    NSDictionary *params=@{@"stockcode": stockCode,@"token": token,@"from": @"googuu"};
    [Utiles getNetInfoWithPath:@"AdjustedData" andParams:params besidesBlock:^(id resObj){
        if(resObj!=nil){
            id saveData=resObj[@"data"];
            NSMutableArray *items=[[[NSMutableArray alloc] init] autorelease];
            for(id data in saveData){
                id tempChartData=data[@"data"];
                NSString *chartStr=[tempChartData JSONString];
                chartStr=[chartStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                [Utiles getObjectDataFromJsFun:self.webView funName: @"chartCalu" byData:chartStr shouldTrans:NO];
                
                [items addObject:data[@"itemname"]];
            }
            [self.delegate savedItemsHasLoaded:items block:^(NSString *title) {
                //NSLog(@"%@",title);
            }];
            if(self.wantSavedType==DiscountSaved){
                [self.discountBt sendActionsForControlEvents: UIControlEventTouchUpInside];
            }else{
                [self modelChanged:self.globalDriverId];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.hostView animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)setStockPrice{
    //NSLog(@"setStockPrice");
    NSString *jsonPrice=[[self.forecastPoints JSONString] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *ggPrice=[Utiles getObjectDataFromJsFun:self.webView funName:@"chartCalu" byData:jsonPrice shouldTrans:NO];
    [self.priceLabel setText:[NSString stringWithFormat:@"%.2f",[ggPrice floatValue]]];
}

-(void)viewPan:(UIPanGestureRecognizer *)tapGr
{
    CGPoint now=[tapGr locationInView:self.view];
    CGPoint change=[tapGr translationInView:self.view];
    CGPoint coordinate=[self CoordinateTransformRealToAbstract:now];
    
    if(tapGr.state==UIGestureRecognizerStateBegan){
        [self.standard removeAllObjects];
        for(id obj in self.forecastPoints){
            [self.standard addObject:obj[@"v"]];
        }
        
    }else if(tapGr.state==UIGestureRecognizerStateEnded){
        [self.standard removeAllObjects];
        
        for(id obj in self.forecastPoints){
            double v = [obj[@"v"] doubleValue];
            [self.standard addObject:@(v)];
        }
        //结束拖动重绘坐标轴 适应新尺寸
        [self setXYAxis];
    }if([tapGr state]==UIGestureRecognizerStateChanged){

        coordinate.x=(int)(coordinate.x+0.5);
        
        int subscript=coordinate.x-[[self.hisPoints lastObject][@"y"] integerValue];
        
        subscript=subscript<0?0:subscript;
        subscript=subscript>=[self.forecastPoints count]-1?[self.forecastPoints count]-1:subscript;
        NSAssert(subscript<=[self.forecastPoints count]-1&&coordinate.x>=0,@"over bounds");
        
        if(_inkage){
            double l4 = YRANGELENGTH*change.y/self.hostView.frame.size.height/ (1 - exp(-2));
            
            double l7 = 2 / ([(self.forecastPoints)[subscript][@"y"] doubleValue]);
            int i=0;
            for(id obj in self.forecastPoints){
                double v = [obj[@"v"] doubleValue];
                v =[(self.standard)[i] doubleValue]- l4 * (1 - exp(-l7 * (i+1)));
                obj[@"v"] = @(v);
                if(i==0){
                    [self.hisPoints lastObject][@"v"] = @(v);
                }
                i++;
            }
            
            [self setStockPrice];
            [self.graph reloadData];
            
        }else{
            
            double changeD=-YRANGELENGTH*change.y/self.hostView.frame.size.height;
            double v=[(self.standard)[subscript] doubleValue]+changeD;
            (self.forecastPoints)[subscript][@"v"] = @(v);
            if(subscript==0){
                [self.hisPoints lastObject][@"v"] = @(v);
            }
            [self setStockPrice];
            [self.graph reloadData];
            
        }
        [self.myGGpriceLabel setHidden:NO];
        [self.priceLabel setHidden:NO];
        if(_isSaved){
            [self.saveBt setEnabled:YES];
            [self.saveBt setBackgroundColor:[Utiles colorWithHexString:@"#3498DB"] forState:UIControlStateNormal];
            _isSaved=NO;
        }
        [self addToDriverIds:self.globalDriverId];
    }
    
}

#pragma mark -
#pragma mark Line Data Source Delegate

// 添加数据标签
-( CPTLayer *)dataLabelForPlot:( CPTPlot *)plot recordIndex:( NSUInteger )index
{
    static CPTMutableTextStyle *whiteText = nil ;
    if ( !whiteText ) {
        whiteText = [[ CPTMutableTextStyle alloc ] init ];
        whiteText.color=[CPTColor blackColor];
        whiteText.fontName=@"Heiti SC";
        whiteText.fontSize=15.0;
    }

    CPTTextLayer *newLayer = nil ;
    NSString * identifier=( NSString *)[plot identifier];
    if ([identifier isEqualToString : FORECAST_DATALINE_IDENTIFIER]) {
        newLayer=[[CPTTextLayer alloc] initWithText:[self formatTrans:index from:self.forecastPoints] style:whiteText];
    }else if([identifier isEqualToString : HISTORY_DATALINE_IDENTIFIER]){
        newLayer=[[CPTTextLayer alloc] initWithText:[self formatTrans:index from:self.hisPoints] style:whiteText];
    }
    return [newLayer autorelease];
}

-(NSString *)formatTrans:(NSUInteger)index from:(NSMutableArray *)arr{
    NSString *numberString =nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    if([self.trueUnit isEqualToString:@"%"]){
        [formatter setPositiveFormat:@"0.0%;0.0%;-0.0%"];
        numberString = [formatter stringFromNumber:@([arr[index][@"v"] floatValue])];
        SAFE_RELEASE(formatter);
    }else{
        numberString=[arr[index][@"v"] stringValue];
        numberString=[Utiles unitConversionData:numberString andUnit:self.yAxisUnit trueUnit:self.trueUnit];
    }
    return numberString;
}

//散点数据源委托实现
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    
    if([(NSString *)plot.identifier isEqualToString:FORECAST_DEFAULT_DATALINE_IDENTIFIER]){
        return [self.forecastDefaultPoints count];
    }else if([(NSString *)plot.identifier isEqualToString:HISTORY_DATALINE_IDENTIFIER]){
        return [self.hisPoints count];
    }else if([(NSString *)plot.identifier isEqualToString:FORECAST_DATALINE_IDENTIFIER]){
        return [self.forecastPoints count];
    }else{
        return [self.forecastPoints count];
    }
    
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger) index{
    
    NSNumber *num=nil;
    
    if([(NSString *)plot.identifier isEqualToString:HISTORY_DATALINE_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        
        if([key isEqualToString:@"x"]){
            num=[(self.hisPoints)[index] valueForKey:@"y"];
        }else if([key isEqualToString:@"y"]){
            num=[(self.hisPoints)[index] valueForKey:@"v"];
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:FORECAST_DATALINE_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        
        if([key isEqualToString:@"x"]){
            num=[(self.forecastPoints)[index] valueForKey:@"y"];
        }else if([key isEqualToString:@"y"]){
            num=[(self.forecastPoints)[index] valueForKey:@"v"];
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:FORECAST_DEFAULT_DATALINE_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        
        if([key isEqualToString:@"x"]){
            num=[(self.forecastDefaultPoints)[index] valueForKey:@"y"];
        }else if([key isEqualToString:@"y"]){
            num=[(self.forecastDefaultPoints)[index] valueForKey:@"v"];
        }
    }else if([(NSString *)plot.identifier isEqualToString:COLUMNAR_DATALINE_IDENTIFIER]){
        
        NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
        if([key isEqualToString:@"x"]){
            num=@([[(self.forecastPoints)[index] valueForKey:@"y"] doubleValue]+0.5);
        }else if([key isEqualToString:@"y"]){
            num=[(self.forecastPoints)[index] valueForKey:@"v"];
        }
        
    }
    
    return  num;
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

            CPTMutableTextStyle * newStyle = [[axis.labelTextStyle mutableCopy] autorelease];
            newStyle.fontSize=16.0;
            newStyle.fontName=@"Heiti SC";

            NSString * labelString      = [Utiles yearFilled:[formatter stringForObjectValue:tickLocation]];
            CPTTextLayer * newLabelLayer= [[[CPTTextLayer alloc] initWithText:labelString style:newStyle] autorelease];
            CPTAxisLabel * newLabel     = [[[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer] autorelease];
            newLabel.tickLocation       = tickLocation.decimalValue;
            newLabel.offset             = 8;
            newLabel.rotation           = 0;
            [newLabels addObject:newLabel];
        }
        
        axis.axisLabels = newLabels;
    }
    return NO;
}


-(void)setXYAxis{
    //NSLog(@"setXYAxis");
    @try {
        NSMutableArray *xTmp=[[NSMutableArray alloc] init];
        NSMutableArray *yTmp=[[NSMutableArray alloc] init];
        for(id obj in self.hisPoints){
            [xTmp addObject:obj[@"y"]];
            [yTmp addObject:obj[@"v"]];
        }
        for(id obj in self.forecastPoints){
            [xTmp addObject:obj[@"y"]];
            [yTmp addObject:obj[@"v"]];
        }
        
        NSDictionary *xyDic=[DrawChartTool getXYAxisRangeFromxArr:xTmp andyArr:yTmp fromWhere:DragabelModel screenHeight:205];
        XRANGEBEGIN=[xyDic[@"xBegin"] floatValue];
        XRANGELENGTH=[xyDic[@"xLength"] floatValue];
        XORTHOGONALCOORDINATE=[xyDic[@"xOrigin"] floatValue];
        XINTERVALLENGTH=[xyDic[@"xInterval"] floatValue];
        YRANGEBEGIN=[xyDic[@"yBegin"] floatValue];
        YRANGELENGTH=[xyDic[@"yLength"] floatValue];
        YORTHOGONALCOORDINATE=[[self.hisPoints lastObject][@"y"] floatValue];
        YINTERVALLENGTH=[xyDic[@"yInterval"] floatValue];
        DrawXYAxis;
        SAFE_RELEASE(xTmp);
        SAFE_RELEASE(yTmp);
        [self.graph reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void)addBarChart{

    if(![self.graph plotWithIdentifier:COLUMNAR_DATALINE_IDENTIFIER]){
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit=0.0f;
        lineStyle.lineWidth=0.0f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:87/255.0 green:168/255.0 blue:9/255.0 alpha:1.0];
        self.barPlot = [CPTBarPlot tubularBarPlotWithColor:[Utiles cptcolorWithHexString:@"#F1C40F" andAlpha:1.0] horizontalBars:NO];
        self.barPlot.baseValue  = CPTDecimalFromFloat(XORTHOGONALCOORDINATE);
        self.barPlot.dataSource = self;
        self.barPlot.barOffset  = CPTDecimalFromFloat(-0.5f);
        self.barPlot.lineStyle=lineStyle;
        self.barPlot.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#3498DB" andAlpha:0.3]];
        self.barPlot.identifier = COLUMNAR_DATALINE_IDENTIFIER;
        self.barPlot.barWidth=CPTDecimalFromFloat(0.5f);
        [self.graph addPlot:self.barPlot];
        lineStyle.lineWidth=0.0f;
        self.forecastLinePlot.dataLineStyle=lineStyle;
        _inkage=NO;
    }
    
}

-(void)addScatterChart{
    //NSLog(@"addScatterChart");
    _inkage=YES;
    if([self.graph plotWithIdentifier:COLUMNAR_DATALINE_IDENTIFIER]){
        [self.graph removePlot:self.barPlot];
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineWidth=2.0f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:87/255.0 green:168/255.0 blue:9/255.0 alpha:1.0];
        self.forecastLinePlot.dataLineStyle=lineStyle;
    }
    
    if(!([self.graph plotWithIdentifier:FORECAST_DATALINE_IDENTIFIER]&&[self.graph plotWithIdentifier:FORECAST_DEFAULT_DATALINE_IDENTIFIER])){
        
        //y. labelingPolicy = CPTAxisLabelingPolicyNone ;
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        //修改折线图线段样式,创建可调整数据线段
        self.forecastLinePlot=[[[CPTScatterPlot alloc] init] autorelease];
        lineStyle.miterLimit=2.0f;
        lineStyle.lineWidth=3.0f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:87/255.0 green:168/255.0 blue:9/255.0 alpha:1.0];
        self.forecastLinePlot.dataLineStyle=lineStyle;
        self.forecastLinePlot.identifier=FORECAST_DATALINE_IDENTIFIER;
        self.forecastLinePlot.labelOffset=10;
        self.forecastLinePlot.dataSource=self;//需实现委托
        //forecastLinePlot.delegate=self;
        
        //创建默认对比数据线
        lineStyle.lineWidth=1.0f;
        lineStyle.lineColor=[Utiles cptcolorWithHexString:@"#9B9689" andAlpha:0.8];
        CPTScatterPlot *ttp = [[[CPTScatterPlot alloc] init] autorelease];
        self.forecastDefaultLinePlot = ttp;
        self.forecastDefaultLinePlot.dataLineStyle = lineStyle;
        self.forecastDefaultLinePlot.identifier = FORECAST_DEFAULT_DATALINE_IDENTIFIER;
        self.forecastDefaultLinePlot.labelOffset=10;
        self.forecastDefaultLinePlot.dataSource = self;
        
        
        //创建历史数据线段
        lineStyle.lineWidth=2.0f;
        lineStyle.lineColor=[CPTColor colorWithComponentRed:144/255.0 green:142/255.0 blue:140/255.0 alpha:1.0];
        CPTScatterPlot *tp = [[[CPTScatterPlot alloc] init] autorelease];
        self.historyLinePlot = tp;
        self.historyLinePlot.dataLineStyle = lineStyle;
        self.historyLinePlot.identifier = HISTORY_DATALINE_IDENTIFIER;
        self.historyLinePlot.labelOffset=10;
        self.historyLinePlot.dataSource = self;
        
        CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
        symbolLineStyle.lineColor = [CPTColor colorWithComponentRed:207/255.0 green:175/255.0 blue:114/255.0 alpha:1.0];
        symbolLineStyle.lineWidth = 0.0;

        CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        plotSymbol.fill          = [CPTFill fillWithImage:[CPTImage imageWithCGImage:[UIImage imageNamed:@"dragDot"].CGImage]];
        plotSymbol.lineStyle     = symbolLineStyle;
        plotSymbol.size          = CGSizeMake(23,23);
        self.forecastLinePlot.plotSymbol = plotSymbol;
        
        symbolLineStyle.lineColor = [CPTColor whiteColor];
        plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor grayColor]];
        plotSymbol.size          = CGSizeMake(8, 8);
        self.historyLinePlot.plotSymbol=plotSymbol;
        
        [self.graph addPlot:self.forecastDefaultLinePlot];
        [self.graph addPlot:self.historyLinePlot];
        [self.graph addPlot:self.forecastLinePlot];
        
    }
    
}

//空间坐标转换:实际坐标转化自定义坐标
-(CGPoint)CoordinateTransformRealToAbstract:(CGPoint)point{
    
    float viewWidth=self.hostView.frame.size.width;
    float viewHeight=self.hostView.frame.size.height;
    
    point.y=point.y-HOSTVIEWTOPPAD;
    
    float coordinateX=(XRANGELENGTH*point.x)/viewWidth+XRANGEBEGIN;
    float coordinateY=YRANGELENGTH-((YRANGELENGTH*point.y)/(viewHeight-GRAPAHBOTTOMPAD-GRAPAHTOPPAD))+YRANGEBEGIN;
    
    return CGPointMake(coordinateX,coordinateY);
}
//空间坐标转换:自定义坐标转化实际坐标
-(CGPoint)CoordinateTransformAbstractToReal:(CGPoint)point{
    
    float viewWidth=self.hostView.frame.size.width;
    float viewHeight=self.hostView.frame.size.height;
    
    float coordinateX=(point.x-XRANGEBEGIN)*viewWidth/XRANGELENGTH;
    float coordinateY=(-1)*(point.y-YRANGEBEGIN-YRANGELENGTH)*(viewHeight-GRAPAHBOTTOMPAD-GRAPAHTOPPAD)/YRANGELENGTH;
    
    return CGPointMake(coordinateX,coordinateY);
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
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
