//
//  DahonValuationViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DahonValuationViewController.h"
#import "DrawChartTool.h"
#import "UIButton+BGColor.h"
#import "RegexKitLite.h"

#define HostViewHeight 520.0

@interface DahonValuationViewController ()

@end

@implementation DahonValuationViewController

static NSString * HISTORY_DATALINE_IDENTIFIER =@"历史股价";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *temp=[NSArray arrayWithObjects:
                       [Utiles cptcolorWithHexString:@"#ffa42f" andAlpha:0.8],
                       [Utiles cptcolorWithHexString:@"#42e069" andAlpha:0.8],
                       [Utiles cptcolorWithHexString:@"#3ec4df" andAlpha:0.8],
                       [Utiles cptcolorWithHexString:@"#ff1a49" andAlpha:0.8],
                       [Utiles cptcolorWithHexString:@"#5a86d5" andAlpha:0.8],
                       [Utiles cptcolorWithHexString:@"#9B59B6" andAlpha:0.8],
                       [Utiles cptcolorWithHexString:@"#bf8fec" andAlpha:0.8],
                       [Utiles cptcolorWithHexString:@"#0c3707" andAlpha:0.8],
                       nil];
        self.defaultColors=temp;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.view setBackgroundColor:[Utiles colorWithHexString:@"#F2EFE1"]];
    [self initDahonViewComponents];
    [self initData];
    
}

-(void)initDahonViewComponents{
    DrawChartTool *tool=[[DrawChartTool alloc] init];
    tool.standIn=self;
    //title
    self.titleLabel=[tool addLabelToView:self.view withTitle:@"" Tag:6 frame:CGRectMake(10,5,800,30) fontSize:19.0 color:nil textColor:@"#63573d" location:NSTextAlignmentLeft];
    
    //提示信息
    [tool addLabelToView:self.view withTitle:@"*点击图标查看大行估值" Tag:6 frame:CGRectMake(820,5,200,30) fontSize:15.0 color:nil textColor:@"#63573d" location:NSTextAlignmentCenter];
    
    self.oneMonth=[tool addButtonToView:self.view withTitle:@"一个月" Tag:OneMonth frame:CGRectMake(10,570,80,30) andFun:@selector(changeDateInter:) withType:UIButtonTypeCustom andColor:nil textColor:@"#e97a31" normalBackGroundImg:nil highBackGroundImg:nil];
    [self.oneMonth.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    self.threeMonth=[tool addButtonToView:self.view withTitle:@"三个月" Tag:ThreeMonth frame:CGRectMake(100,570,80,30) andFun:@selector(changeDateInter:) withType:UIButtonTypeCustom andColor:nil textColor:@"#e97a31" normalBackGroundImg:nil highBackGroundImg:nil];
    [self.threeMonth.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    self.sixMonth=[tool addButtonToView:self.view withTitle:@"六个月" Tag:SixMonth frame:CGRectMake(190,570,80,30) andFun:@selector(changeDateInter:) withType:UIButtonTypeCustom andColor:nil textColor:@"#e97a31" normalBackGroundImg:nil highBackGroundImg:nil];
    [self.sixMonth.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    self.oneYear=[tool addButtonToView:self.view withTitle:@"一年" Tag:OneYear frame:CGRectMake(290,570,80,30) andFun:@selector(changeDateInter:) withType:UIButtonTypeCustom andColor:nil textColor:@"#FFFEFE" normalBackGroundImg:@"monthChoosenBt" highBackGroundImg:nil];
    [self.oneYear.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    self.lastMarkBt=self.oneYear;
    [self.oneMonth setEnabled:NO];
    [self.threeMonth setEnabled:NO];
    [self.sixMonth setEnabled:NO];
    [self.oneYear setEnabled:NO];
    SAFE_RELEASE(tool);
}

-(void)changeDateInter:(UIButton *)bt{
    bt.showsTouchWhenHighlighted=YES;
    int count=[self.dateArr count];
    if(bt.tag==OneMonth){
        [self changeBtState:self.oneMonth];
        XRANGEBEGIN=count-24;
        XRANGELENGTH=24;
        XINTERVALLENGTH=4.5;
    }else if(bt.tag==ThreeMonth){
        [self changeBtState:self.threeMonth];
        XRANGEBEGIN=count-60;
        XRANGELENGTH=59;
        XINTERVALLENGTH=10.7;
    }else if(bt.tag==SixMonth){
        [self changeBtState:self.sixMonth];
        XRANGEBEGIN=count-130;
        XRANGELENGTH=129;
        XINTERVALLENGTH=23;
    }else if(bt.tag==OneYear){
        [self changeBtState:self.oneYear];
        XRANGEBEGIN=count-269;
        XRANGELENGTH=269;
        XINTERVALLENGTH=50;
    }
    [self setXYAxis];
}

-(void)changeBtState:(UIButton *)nowBt{
    [self.lastMarkBt setBackgroundImage:nil forState:UIControlStateNormal];
    [self.lastMarkBt.titleLabel setTextColor:[Utiles colorWithHexString:@"#e97a31"]];
    [nowBt setBackgroundImage:[UIImage imageNamed:@"monthChoosenBt"] forState:UIControlStateNormal];
    [nowBt setTitleColor:[Utiles colorWithHexString:@"#FFFEFE"] forState:UIControlStateNormal];
    CATransition *transition=[CATransition animation];
    transition.duration=0.3f;
    transition.fillMode=kCAFillRuleNonZero;
    transition.type=kCATransitionMoveIn;
    transition.subtype=kCATransitionFromTop;
    [nowBt.layer addAnimation:transition forKey:@"animation"];
    transition.type=kCATransitionFade;
    transition.subtype=kCATransitionFromTop;
    [self.lastMarkBt.layer addAnimation:transition forKey:@"animation"];
    self.lastMarkBt=nowBt;
}

-(void)initChart{
    
    CPTXYGraph *tg=[[[CPTXYGraph alloc] initWithFrame:CGRectZero] autorelease];
    self.graph=tg;
    CPTFill *tf=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#ffffff" andAlpha:0.9]];
    self.graph.fill=tf;
    
    CPTGraphHostingView *tHostView=[[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(10,40,SCREEN_HEIGHT-20,HostViewHeight)] autorelease];
    self.hostView=tHostView;
    [self.view addSubview:self.hostView];
    [self.hostView setHostedGraph : self.graph ];
    self.graph . paddingLeft = 0.0f ;
    self.graph . paddingRight = 0.0f ;
    self.graph . paddingTop = 0 ;
    self.graph . paddingBottom = 0 ;
    
    self.graph.plotAreaFrame.paddingTop    = 10.0;
    self.graph.plotAreaFrame.paddingBottom = 50.0;
    self.graph.plotAreaFrame.paddingLeft   = 70.0;
    self.graph.plotAreaFrame.paddingRight  = 0.0;
    self.graph.plotAreaFrame.masksToBorder = NO;
    
    //graph.title=@"大行估值";
    [self.titleLabel setText:@"大行估值"];
    //绘制图形空间
    self.plotSpace=(CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    self.plotSpace.allowsUserInteraction=YES;
    [self.hostView setAllowPinchScaling:YES];
    DrawXYAxisWithoutXAxisOrYAxis;
    [self addScatterChart];
}


-(void)initData{
    
    NSDictionary *params=@{@"stockcode": self.comInfo[@"stockcode"]};
    [Utiles getNetInfoWithPath:@"GetStockHistoryData" andParams:params besidesBlock:^(id resObj){
        NSNumberFormatter * formatter   = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:@"##.##"];
        self.jsonData=resObj;
        self.hisLineData=resObj[@"stockHistoryData"][@"data"];
        id info=resObj[@"stockHistoryData"][@"info"];
        
        NSString *open=[formatter stringForObjectValue:info[@"open"]==nil?@"":info[@"open"]];
        NSString *close=[formatter stringForObjectValue:info[@"close"]==nil?@"":info[@"close"]];
        NSString *high=[formatter stringForObjectValue:info[@"high"]==nil?@"":info[@"high"]];
        NSString *low=[formatter stringForObjectValue:info[@"low"]==nil?@"":info[@"low"]];
        [formatter setPositiveFormat:@"#,###"];
        NSString *volume=[formatter stringFromNumber:info[@"volume"]];
        NSString *indicator=[NSString stringWithFormat:@"昨开盘:%@   昨收盘:%@   最高价:%@   最低价:%@   成交量:%@",open,close,high,low,volume];
        SAFE_RELEASE(formatter);
        self.dateArr=[Utiles sortDateArr:self.hisLineData];
        
        [self setDateMap];
        
        int count=[self.dateArr count];
        XRANGEBEGIN=count-269;
        XRANGELENGTH=269;
        XINTERVALLENGTH=50;
        [MBProgressHUD hideHUDForView:self.hostView animated:YES];
        
        [self initChart];
        [self setXYAxis];
        [self.titleLabel setText:indicator];
        
        [self.oneMonth setEnabled:YES];
        [self.threeMonth setEnabled:YES];
        [self.sixMonth setEnabled:YES];
        [self.oneYear setEnabled:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        [self.oneMonth setEnabled:NO];
        [self.threeMonth setEnabled:NO];
        [self.sixMonth setEnabled:NO];
        [self.oneYear setEnabled:NO];
    }];
}

-(void)buildDhDic:(NSMutableDictionary *)tempDic source:(id)dataDic{
    for (id key in dataDic) {
        for (id obj in dataDic[key]) {
            if (![[tempDic allKeys] containsObject:obj[@"dahonName"]]) {
                NSMutableArray *arr=[NSMutableArray arrayWithObject:obj];
                [tempDic setObject:arr forKey:obj[@"dahonName"]];
            }else {
                NSMutableArray *temps=tempDic[obj[@"dahonName"]];
                [temps addObject:obj];
            }
        }
    }
}

-(void)setDateMap{
    
    //将大行估值与估股估值统一放入大行字典
    NSMutableDictionary *tempDhDic=[[[NSMutableDictionary alloc] init] autorelease];
    [self buildDhDic:tempDhDic source:self.jsonData[@"dahonData"]];
    [self buildDhDic:tempDhDic source:self.jsonData[@"googuuData"]];
    self.dhDic=tempDhDic;
    
    //设置横坐标与时间的对应关系
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] init];
    for(int i=0;i<[self.dateArr count];i++){
        [tempDic setValue:@(i) forKey:(self.dateArr)[i]];
    }
    self.dateIndexMap=tempDic;
    
    //组建大行估值点坐标
    NSMutableDictionary *tempDcCodePointsDic=[[[NSMutableDictionary alloc] init] autorelease];
    NSString *regexString  = @"\\d+.\\d+|\\d+";
    for (id key in self.dhDic) {
        NSMutableArray *points=[[[NSMutableArray alloc] init] autorelease];
        for (id obj in self.dhDic[key]) {
            id x=[self dateToIndex:obj[@"date"]];
            NSArray  *matchArray   = NULL;
            matchArray = [obj[@"desc"] componentsMatchedByRegex:regexString];
            id y=[matchArray lastObject];
            if ([matchArray count]>0) {
                NSDictionary *point=@{@"x":x,@"y":y};
                [points addObject:point];
            }
            
        }
        [tempDcCodePointsDic setObject:points forKey:key];
    }
    self.dhCodePointsDic=tempDcCodePointsDic;
    SAFE_RELEASE(tempDic);
}

-(id)dateToIndex:(NSString *)date{
    NSMutableArray *scoreCounter=[[[NSMutableArray alloc] init] autorelease];
    if ([self.dateArr containsObject:date]) {
        [scoreCounter addObject:self.dateIndexMap[date]];
        return self.dateIndexMap[date];
    }else {
        for(int n=[scoreCounter count]==0?0:[[scoreCounter lastObject] intValue];n<[self.dateArr count];n++){
            if([Utiles isDate1:self.dateArr[n] beforeThanDate2:date]){
                continue;
            }else{
                [scoreCounter addObject:@(n-1)];
                return [NSNumber numberWithInt:n];
            }
        }
        return [NSNumber numberWithInt:[self.dateArr count]-1];
    }
}

-(void)setXYAxis{

    [self lineShowWithAnimation];
    NSMutableArray *xTmp=[[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *yTmp=[[[NSMutableArray alloc] init] autorelease];
    int n=0;
    for(id obj in self.dateArr){
        [xTmp addObject:@(n++)];
    }
    for(id obj in self.hisLineData){
        [yTmp addObject:self.hisLineData[obj][@"close"]];
    }
    for (id key in self.dhCodePointsDic) {
        for (id obj in self.dhCodePointsDic[key]) {
            [yTmp addObject:obj[@"y"]];
        }
    }
    NSDictionary *xyDic=[DrawChartTool getXYAxisRangeFromxArr:xTmp andyArr:yTmp fromWhere:DahonModel screenHeight:HostViewHeight];
    XORTHOGONALCOORDINATE=[xyDic[@"xOrigin"] doubleValue];
    YRANGEBEGIN=[xyDic[@"yBegin"] doubleValue];
    YRANGELENGTH=[xyDic[@"yLength"] doubleValue];
    YORTHOGONALCOORDINATE=[xyDic[@"yOrigin"] doubleValue];
    YINTERVALLENGTH=[xyDic[@"yInterval"] doubleValue];
    self.plotSpace.globalYRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(YRANGEBEGIN) length:CPTDecimalFromDouble(YRANGELENGTH)];
    self.plotSpace.globalXRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-30) length:CPTDecimalFromDouble(320)];
    DrawXYAxisWithoutXAxisOrYAxis;
    [self.graph reloadData];
}

-(void)reflash:(UIButton *)bt{
    [MBProgressHUD showHUDAddedTo:self.hostView animated:YES];
    [self initData];
    
}

-(void)backTo:(UIButton *)bt{
    bt.showsTouchWhenHighlighted=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}


//散点数据源委托实现
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    int count=0;
    if([(NSString *)plot.identifier isEqualToString:HISTORY_DATALINE_IDENTIFIER]){
        if(self.hisLineData){
            count=[self.hisLineData count];
        }else{
            count=0;
        }
    }else {
        for (id identifier in self.identifiers) {
            if ([identifier isEqual:(NSString *)plot.identifier]) {
                count=[self.dhCodePointsDic[identifier] count];
            }
        }
    }
    return count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger) index{
    
    NSNumber *num=nil;
    if([(NSString *)plot.identifier isEqualToString:HISTORY_DATALINE_IDENTIFIER]){
        
        if(index<[self.dateArr count]){
            NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
            @try {
                if([key isEqualToString:@"x"]){
                    num=[NSNumber numberWithInt:index] ;
                }else if([key isEqualToString:@"y"]){
                    num=[self.hisLineData valueForKey:(self.dateArr)[index]][@"close"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        
    } else {
        for (id identifier in self.identifiers) {
            if ([identifier isEqual:(NSString *)plot.identifier]) {
                NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
                NSDictionary *point=self.dhCodePointsDic[identifier][index];
                num = point[key];
            }
        }
    }
    return  num;
}

#pragma mark -
#pragma mark Scatter Plot Methods Delegate

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx{
    for (id identifier in self.identifiers) {
        if ([identifier isEqual:(NSString *)plot.identifier]) {
            [Utiles showToastView:self.view withTitle:identifier andContent:self.dhDic[identifier][idx][@"desc"] duration:2.5];
            return;
        }
    }
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
            newStyle.color=[CPTColor blackColor];
            
            NSString * labelString      = [formatter stringForObjectValue:tickLocation];
            NSString *str=nil;
            if([self.dateArr count]>10){
                if([labelString intValue]<=[self.dateArr count]-1&&[labelString intValue]>=0){
                    str=(self.dateArr)[[labelString intValue]];
                }else{
                    str=@"";
                }
            }
            CPTTextLayer * newLabelLayer= [[[CPTTextLayer alloc] initWithText:str style:newStyle] autorelease];
            CPTAxisLabel * newLabel     = [[[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer] autorelease];
            newLabel.tickLocation       = tickLocation.decimalValue;
            
            [newLabels addObject:newLabel];
        }        
        axis.axisLabels = newLabels;
        
    }else{
        NSNumberFormatter * formatter   = (NSNumberFormatter *)axis.labelFormatter;
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setPositiveFormat:@"##.##"];
        NSMutableSet * newLabels        = [NSMutableSet set];

        for (NSDecimalNumber * tickLocation in locations) {

            CPTMutableTextStyle * newStyle = [[axis.labelTextStyle mutableCopy] autorelease];
            newStyle.fontSize=15.0;
            newStyle.fontName=@"Heiti SC";
            newStyle.color=[CPTColor blackColor];

            NSString * labelString      = [formatter stringForObjectValue:tickLocation];
            CPTTextLayer * newLabelLayer= [[[CPTTextLayer alloc] initWithText:labelString style:newStyle] autorelease];
            CPTAxisLabel * newLabel     = [[[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer] autorelease];
            newLabel.tickLocation       = tickLocation.decimalValue;
            newLabel.offset             = 20;
            [newLabels addObject:newLabel];
        }
        axis.axisLabels = newLabels;
    }
    return NO;
}

-(void)addScatterChart{
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];

    CPTScatterPlot *c1=[[[CPTScatterPlot alloc] init] autorelease];
    self.historyLinePlot=c1;
    lineStyle.miterLimit=2.0f;
    lineStyle.lineWidth=2.0f;
    //[UIColor peterRiverColor]
    lineStyle.lineColor=[Utiles cptcolorWithHexString:@"#2980B9" andAlpha:1.0];
    self.historyLinePlot.dataLineStyle=lineStyle;
    self.historyLinePlot.identifier=HISTORY_DATALINE_IDENTIFIER;
    self.historyLinePlot.labelOffset=5;
    self.historyLinePlot.dataSource=self;
    self.historyLinePlot.delegate=self;
    
    
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [Utiles cptcolorWithHexString:@"#2980B9" andAlpha:1.0];
    symbolLineStyle.lineWidth = 1.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(20, 20);
    NSMutableArray *tempLines=[[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *tempIdentifiers=[[[NSMutableArray alloc] init] autorelease];
    int n=0;
    for (id key in self.dhDic) {
        CPTScatterPlot *line=[[[CPTScatterPlot alloc] init] autorelease];
        lineStyle.miterLimit=0.0f;
        lineStyle.lineWidth=0.0f;
        lineStyle.lineColor=[CPTColor clearColor];
        line.dataLineStyle=lineStyle;
        line.identifier=key;
        line.labelOffset=5;
        line.dataSource=self;
        line.delegate=self;
        
        if ([key isEqualToString:@"估股网"]) {
            plotSymbol = [CPTPlotSymbol trianglePlotSymbol];
            symbolLineStyle.lineWidth = 0.0;
            plotSymbol.fill          = [CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#498641" andAlpha:1.0]];
            
        }else {
            plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
            symbolLineStyle.lineWidth = 1.0;
            plotSymbol.fill  = [CPTFill fillWithColor:self.defaultColors[n++]];
        }
        plotSymbol.lineStyle     = symbolLineStyle;
        plotSymbol.size          = CGSizeMake(20, 20);
        line.plotSymbol = plotSymbol;
        [tempIdentifiers addObject:key];
        [tempLines addObject:line];
        [self.graph addPlot:line];
    }
    self.lines=tempLines;
    self.identifiers=tempIdentifiers;

    self.historyLinePlot.opacity = 0.0f;
    [self lineShowWithAnimation];
    
    CPTColor *areaColor       = [CPTColor purpleColor];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor blackColor]];
    areaGradient.angle = 0.0f;
    self.historyLinePlot.areaFill      = [CPTFill fillWithGradient:areaGradient];
    
    [self.graph addPlot:self.historyLinePlot];
    
    // Add legend
    self.graph.legend                    = [CPTLegend legendWithGraph:self.graph];
    //self.graph.legend.textStyle          = lineStyle;
    self.graph.legend.fill               = self.graph.plotAreaFrame.fill;
    self.graph.legend.borderLineStyle    = self.graph.plotAreaFrame.borderLineStyle;
    self.graph.legend.cornerRadius       = 5.0;
    self.graph.legend.swatchSize         = CGSizeMake(25.0, 25.0);
    self.graph.legend.swatchCornerRadius = 5.0;
    self.graph.legend.numberOfRows       = 1;
    self.graph.legendAnchor              = CPTRectAnchorTopLeft;
    self.graph.legendDisplacement        = CGPointMake(80.0, 0.0);
    
}
-(void)lineShowWithAnimation{
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 1.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeBoth;
    fadeInAnimation.toValue             = @1.0f;
    [self.historyLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (BOOL)shouldAutorotate
{
    
    return NO;
}










@end
