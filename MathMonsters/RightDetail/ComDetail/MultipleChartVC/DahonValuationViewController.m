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

#define HostViewHeight 520.0

@interface DahonValuationViewController ()

@end

@implementation DahonValuationViewController

static NSString * DAHON_DATALINE_IDENTIFIER =@"dahon_dataline_identifier";
static NSString * GOOGUU_DATALINE_IDENTIFIER =@"googuu_dataline_identifier";
static NSString * HISTORY_DATALINE_IDENTIFIER =@"history_dataline_identifier";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.titleLabel=[tool addLabelToView:self.view withTitle:@"" Tag:6 frame:CGRectMake(10,5,600,30) fontSize:19.0 color:nil textColor:@"#63573d" location:NSTextAlignmentLeft];
    
    //提示信息
    [tool addLabelToView:self.view withTitle:@"*点击图标查看大行估值" Tag:6 frame:CGRectMake(620,5,200,30) fontSize:15.0 color:nil textColor:@"#63573d" location:NSTextAlignmentCenter];
    
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
    graph=[[CPTXYGraph alloc] initWithFrame:CGRectZero];
    graph.fill=[CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#ffffff" andAlpha:0.9]];
    
    CPTGraphHostingView *tHostView=[[[ CPTGraphHostingView alloc ] initWithFrame :CGRectMake(10,40,SCREEN_HEIGHT-20,HostViewHeight)] autorelease];
    self.hostView=tHostView;
    [self.view addSubview:self.hostView];
    [self.hostView setHostedGraph : graph ];
    graph . paddingLeft = 0.0f ;
    graph . paddingRight = 0.0f ;
    graph . paddingTop = 0 ;
    graph . paddingBottom = 0 ;
    
    graph.plotAreaFrame.paddingTop    = 10.0;
    graph.plotAreaFrame.paddingBottom = 50.0;
    graph.plotAreaFrame.paddingLeft   = 70.0;
    graph.plotAreaFrame.paddingRight  = 0.0;
    graph.plotAreaFrame.masksToBorder = NO;
    
    //graph.title=@"大行估值";
    [self.titleLabel setText:@"大行估值"];
    //绘制图形空间
    self.plotSpace=(CPTXYPlotSpace *)graph.defaultPlotSpace;
    self.plotSpace.allowsUserInteraction=YES;
    [self.hostView setAllowPinchScaling:YES];
    DrawXYAxisWithoutXAxisOrYAxis;
    [self addScatterChart];
}


-(void)initData{
    
    NSDictionary *params=@{@"stockcode": self.comInfo[@"stockcode"]};
    [Utiles getNetInfoWithPath:@"GetStockHistoryData" andParams:params besidesBlock:^(id resObj){
        NSLog(@"%s",__FUNCTION__);
        NSNumberFormatter * formatter   = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setPositiveFormat:@"##.##"];
        self.chartData=resObj[@"stockHistoryData"][@"data"];
        id info=resObj[@"stockHistoryData"][@"info"];
        
        NSString *open=[formatter stringForObjectValue:info[@"open"]==nil?@"":info[@"open"]];
        NSString *close=[formatter stringForObjectValue:info[@"close"]==nil?@"":info[@"close"]];
        NSString *high=[formatter stringForObjectValue:info[@"high"]==nil?@"":info[@"high"]];
        NSString *low=[formatter stringForObjectValue:info[@"low"]==nil?@"":info[@"low"]];
        NSString *volume=[NSString stringWithFormat:@"%@",info[@"volume"]==nil?@"":info[@"volume"]];
        NSString *indicator=[NSString stringWithFormat:@"昨开盘:%@ 昨收盘:%@ 最高价:%@ 最低价:%@ 成交量:%@",open,close,high,low,volume];
 
        self.dateArr=[Utiles sortDateArr:self.chartData];
        self.daHonDataDic=resObj[@"dahonData"];
        self.gooGuuDataDic=resObj[@"googuuData"];
        
        [self setDateMap];
        
        int count=[self.dateArr count];
        XRANGEBEGIN=count-269;
        XRANGELENGTH=269;
        XINTERVALLENGTH=50;
        [MBProgressHUD hideHUDForView:self.hostView animated:YES];
        SAFE_RELEASE(formatter);
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

-(void)setDateMap{
    
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] init];
    for(int i=0;i<[self.dateArr count];i++){
        [tempDic setValue:@(i) forKey:(self.dateArr)[i]];
    }
    
    self.daHonIndexDateMap=[self dateRestruct:tempDic keys:[Utiles sortDateArr:[self.daHonDataDic allKeys]]];
    self.daHonIndexSets=[self.daHonIndexDateMap allKeys];
    
    self.gooGuuIndexDateMap=[self dateRestruct:tempDic keys:[Utiles sortDateArr:[self.gooGuuDataDic allKeys]]];
    self.gooGuuIndexSets=[self.gooGuuIndexDateMap allKeys];
    
    SAFE_RELEASE(tempDic);
    
}

-(NSMutableDictionary *)dateRestruct:(NSMutableDictionary *)tempDic keys:(NSArray *)keys{
    NSMutableDictionary *tempMap=[[NSMutableDictionary alloc] init];
    NSMutableArray *scoreCounter=[[NSMutableArray alloc] init];
    NSArray *dates=[Utiles sortDateArr:[tempDic allKeys]];
    BOOL isAdd=NO;
    for(id key in keys){
        if([dates containsObject:key]){
            [tempMap setValue:key forKey:[NSString stringWithFormat:@"%@",tempDic[key]]];
            [scoreCounter addObject:tempDic[key]];
        }else{
            for(int n=[scoreCounter count]==0?0:[[scoreCounter lastObject] intValue];n<[dates count];n++){
                if([Utiles isDate1:dates[n] beforeThanDate2:key]){
                    continue;
                }else{
                    [tempMap setValue:key forKey:[NSString stringWithFormat:@"%d",n]];
                    [scoreCounter addObject:@(n-1)];
                    isAdd=YES;
                    break;
                }
            }
            if(!isAdd){
                [tempMap setValue:key forKey:[NSString stringWithFormat:@"%d",[dates count]-1]];
            }
        }
        
    }
    SAFE_RELEASE(scoreCounter);
    return [tempMap autorelease];
}

-(void)setXYAxis{

    [self lineShowWithAnimation];
    NSMutableArray *xTmp=[[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *yTmp=[[[NSMutableArray alloc] init] autorelease];
    int n=0;
    for(id obj in self.dateArr){
        [xTmp addObject:@(n++)];
    }
    for(id obj in self.chartData){
        [yTmp addObject:(self.chartData)[obj][@"close"]];
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
    [graph reloadData];
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
        if(self.chartData){
            count=[self.chartData count];
        }else{
            count=0;
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:DAHON_DATALINE_IDENTIFIER]){
        if(self.daHonIndexSets){
            count=[self.daHonIndexSets count];
        }else{
            count=0;
        }
    }else if([(NSString *)plot.identifier isEqualToString:GOOGUU_DATALINE_IDENTIFIER]){
        if(self.gooGuuIndexSets){
            count=[self.gooGuuIndexSets count];
        }else{
            count=0;
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
                    num=[self.chartData valueForKey:(self.dateArr)[index]][@"close"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:DAHON_DATALINE_IDENTIFIER]){
        if(index<[self.daHonIndexSets count]){
            @try {
                NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
                NSInteger trueIndex=[(self.daHonIndexSets)[index] intValue];
                if([key isEqualToString:@"x"]){
                    num=@(trueIndex);
                }else if([key isEqualToString:@"y"]){
                    num=[self.chartData valueForKey:(self.dateArr)[trueIndex]][@"close"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        
    }else if([(NSString *)plot.identifier isEqualToString:GOOGUU_DATALINE_IDENTIFIER]){
        if(index<[self.gooGuuIndexSets count]){
            @try {
                NSString *key=(fieldEnum==CPTScatterPlotFieldX?@"x":@"y");
                NSInteger trueIndex=[(self.gooGuuIndexSets)[index] intValue];
                if([key isEqualToString:@"x"]){
                    num=@(trueIndex);
                }else if([key isEqualToString:@"y"]){
                    num=[self.chartData valueForKey:(self.dateArr)[trueIndex]][@"close"];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        
    }
    return  num;
}

#pragma mark -
#pragma mark Scatter Plot Methods Delegate
-(NSDictionary *)getDataFromDic:(NSDictionary *)dic dateMap:(NSMutableDictionary *)map andArr:(NSArray *)sets byIndex:(NSUInteger)idx{
    
    NSString *msg=[[[NSString alloc] init] autorelease];
    NSString *title=nil;
    NSNumber *trueIndex=@([sets[idx] intValue]);
    NSString *date=map[[NSString stringWithFormat:@"%@",trueIndex]];
    id data=dic[date];
    title=[NSString stringWithFormat:@"%@",date];
    for(id obj in data){
        msg=[msg stringByAppendingFormat:@"%@:%@\n",obj[@"dahonName"],obj[@"desc"]];
    }
    return @{@"msg": msg,@"title": title};
}

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx{
    NSDictionary *info=nil;
    NSDictionary *info2=nil;
    if(plot.identifier==GOOGUU_DATALINE_IDENTIFIER){
        info=[self getDataFromDic:self.gooGuuDataDic dateMap:self.gooGuuIndexDateMap andArr:self.gooGuuIndexSets byIndex:idx];
        if([self.daHonIndexSets containsObject:(self.gooGuuIndexSets)[idx]]){
            info2=[self getDataFromDic:self.daHonDataDic dateMap:self.daHonIndexDateMap andArr:self.daHonIndexSets byIndex:idx];
        }
    }else if(plot.identifier==DAHON_DATALINE_IDENTIFIER){
        info=[self getDataFromDic:self.daHonDataDic dateMap:self.daHonIndexDateMap andArr:self.daHonIndexSets byIndex:idx];
    }
    NSString *msg=nil;
    if(info2){
        msg=[NSString stringWithFormat:@"%@%@",info[@"msg"],info2[@"msg"]];
    }else{
        msg=[NSString stringWithFormat:@"%@",info[@"msg"]];
    }
    [Utiles showToastView:self.view withTitle:info[@"title"] andContent:msg duration:1.5];
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
    
    
    
    CPTScatterPlot *c2=[[[CPTScatterPlot alloc] init] autorelease];
    self.daHonLinePlot=c2;
    lineStyle.miterLimit=0.0f;
    lineStyle.lineWidth=0.0f;
    lineStyle.lineColor=[CPTColor clearColor];
    self.daHonLinePlot.dataLineStyle=lineStyle;
    self.daHonLinePlot.identifier=DAHON_DATALINE_IDENTIFIER;
    self.daHonLinePlot.labelOffset=5;
    self.daHonLinePlot.dataSource=self;
    self.daHonLinePlot.delegate=self;
    
    CPTScatterPlot *c3=[[[CPTScatterPlot alloc] init] autorelease];
    self.gooGuuLinePlot=c3;
    lineStyle.miterLimit=0.0f;
    lineStyle.lineWidth=0.0f;
    lineStyle.lineColor=[CPTColor clearColor];
    self.gooGuuLinePlot.dataLineStyle=lineStyle;
    self.gooGuuLinePlot.identifier=GOOGUU_DATALINE_IDENTIFIER;
    self.gooGuuLinePlot.labelOffset=5;
    self.gooGuuLinePlot.dataSource=self;
    self.gooGuuLinePlot.delegate=self;
    
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [Utiles cptcolorWithHexString:@"#2980B9" andAlpha:1.0];
    symbolLineStyle.lineWidth = 1.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#9B59B6" andAlpha:0.8]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(20, 20);
    
    self.daHonLinePlot.plotSymbol = plotSymbol;
    
    plotSymbol = [CPTPlotSymbol trianglePlotSymbol];
    plotSymbol.lineStyle     = symbolLineStyle;
    symbolLineStyle.lineWidth = 0.0;
    plotSymbol.fill          = [CPTFill fillWithColor:[Utiles cptcolorWithHexString:@"#498641" andAlpha:1.0]];
    plotSymbol.size          = CGSizeMake(20, 20);
    self.gooGuuLinePlot.plotSymbol=plotSymbol;
    
    self.historyLinePlot.opacity = 0.0f;
    self.daHonLinePlot.opacity = 0.0f;
    self.gooGuuLinePlot.opacity=0.0f;
    [self lineShowWithAnimation];
    
    CPTColor *areaColor       = [CPTColor purpleColor];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor blackColor]];
    areaGradient.angle = 0.0f;
    self.historyLinePlot.areaFill      = [CPTFill fillWithGradient:areaGradient];
    self.daHonLinePlot.areaFill      = [CPTFill fillWithGradient:areaGradient];
    self.gooGuuLinePlot.areaFill      = [CPTFill fillWithGradient:areaGradient];
    
    [graph addPlot:self.historyLinePlot];
    [graph addPlot:self.daHonLinePlot];
    [graph addPlot:self.gooGuuLinePlot];
    
}
-(void)lineShowWithAnimation{
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 1.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeBoth;
    fadeInAnimation.toValue             = @1.0f;
    [self.daHonLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    [self.historyLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    [self.gooGuuLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
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
