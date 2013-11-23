//
//  ComInfoListColumn2.m
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComInfoListColumn2.h"
#import "ValueModelIndicator2.h"
#import "ValueModelCell.h"
#import "ValueModelCell2.h"
#import "AMProgressView.h"
#import "ComContainerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ComInfoListColumn2 ()

@end

@implementation ComInfoListColumn2

- (id)initWithMarkType:(MarketType)type
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    
    [self initComponents];
    
}

-(void)initComponents{
    
    ValueModelIndicator2 *indicator=[[[ValueModelIndicator2 alloc] initWithFrame:CGRectMake(0,0, 790, 60)] autorelease];
    [self.view addSubview:indicator];

}


#pragma mark -
#pragma Table DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comList count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueModelCell2Identifier = @"ValueModelCell2Identifier";
    ValueModelCell2 *cell = (ValueModelCell2 *)[tableView dequeueReusableCellWithIdentifier:ValueModelCell2Identifier];
    if (cell == nil) {
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ValueModelCell" owner:self options:nil];
//        cell = [array objectAtIndex:1];
        cell=[[[ValueModelCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ValueModelCell2Identifier] autorelease];
    }
    if(self.comList){
        for(UIView *view in cell.contentView.subviews){
            if([view isKindOfClass:NSClassFromString(@"AMProgressView")]){
                [view removeFromSuperview];
            }
        }
        if([self.progressArr count]>0){
            for(UIView *view in self.progressArr[indexPath.row]){
                [cell.contentView addSubview:view];
            }
        }
        [self setCell:cell classDic:self.yearValueArr[indexPath.row]];
        cell.contentView.backgroundColor=[Utiles colorWithHexString:@"#452A21"];
    }
    return cell;
}

-(void)setCell:(ValueModelCell2 *)cell classDic:(NSDictionary *)dic{

    [self setCellProcess:cell yearValueDic:dic[@"Revenue growth rate"] yearLableArr:[NSArray arrayWithObjects:cell.row00,cell.row10,cell.row20,cell.row30, nil] valueLable:[NSArray arrayWithObjects:cell.row01,cell.row11,cell.row21,cell.row31, nil] x:55];
    
    [self setCellProcess:cell yearValueDic:dic[@"Net income growth rate"] yearLableArr:[NSArray arrayWithObjects:cell.row02,cell.row12,cell.row22,cell.row32, nil] valueLable:[NSArray arrayWithObjects:cell.row03,cell.row13,cell.row23,cell.row33, nil] x:310];
    
    [self setCellProcess:cell yearValueDic:dic[@"Gross profit margin"] yearLableArr:[NSArray arrayWithObjects:cell.row04,cell.row14,cell.row24,cell.row34, nil] valueLable:[NSArray arrayWithObjects:cell.row05,cell.row15,cell.row25,cell.row35, nil] x:570];
}

-(void)setCellProcess:(ValueModelCell2 *)cell yearValueDic:(id)dic yearLableArr:(NSArray *)labels1 valueLable:(NSArray *)labels2 x:(int)x{
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    if (![dic isKindOfClass:[NSNull class]]) {
        int n=0;
        NSArray *keys=[[dic allKeys] sortedArrayUsingComparator:cmptr];
        for(id key in keys){
            UILabel *label= labels1[n];
            [label setText:[NSString stringWithFormat:@"20%@",key]];
            label=labels2[n];
            [label setText:[formatter stringFromNumber:dic[key]]];
            n++;
        }
    }
}

-(void)produceProgressForTable{
    
    NSArray *colorArr=[NSArray arrayWithObjects:[Utiles colorWithHexString:@"#fd9e1b"],[Utiles colorWithHexString:@"#f60933"],[Utiles colorWithHexString:@"#03d234"],[Utiles colorWithHexString:@"#0db4b4"], nil];
    
    NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *tempYearValueArr=[[[NSMutableArray alloc] init] autorelease];
    for(id obj in self.progressArr){
        [temp addObject:obj];
    }
    for(id obj in self.yearValueArr){
        [tempYearValueArr addObject:obj];
    }
    for(id comInfo in self.comList){
        NSMutableArray *tempGrade2=[[[NSMutableArray alloc] init] autorelease];
        
        NSMutableDictionary *cellValueDic=[[[NSMutableDictionary alloc] init] autorelease];
        
        [self produceProgressForClass:comInfo[@"data"] className:@"Revenue growth rate" tempGrade2:tempGrade2 cellValueDic:cellValueDic color:colorArr x:55];
        [self produceProgressForClass:comInfo[@"data"] className:@"Net income growth rate" tempGrade2:tempGrade2 cellValueDic:cellValueDic color:colorArr x:310];
        [self produceProgressForClass:comInfo[@"data"] className:@"Gross profit margin" tempGrade2:tempGrade2 cellValueDic:cellValueDic color:colorArr x:570];
        
        [temp addObject:tempGrade2];
        [tempYearValueArr addObject:cellValueDic];
    }
    self.progressArr=temp;
    self.yearValueArr=tempYearValueArr;
}

-(void)produceProgressForClass:(id)data className:(NSString *)className tempGrade2:(NSMutableArray *)tempArr cellValueDic:(NSMutableDictionary *)cellValueDic color:(NSArray *)colorArr x:(int)x{

    id classData=data[className];
    if (![classData isKindOfClass:[NSNull class]]) {
        NSArray *dataArr=nil;
        if ([classData[@"array"] count]>4) {
            NSMutableArray *temp=[NSMutableArray arrayWithCapacity:4];
            for(int i=[classData[@"array"] count]-1,j=3;j>=0;j--,i--){
                [temp addObject:classData[@"array"][i]];
            }
            dataArr=[[temp reverseObjectEnumerator] allObjects];;
        } else {
            dataArr=classData[@"array"];
        }
        
        int n=0;
        NSMutableDictionary *tempGrade2Dic=[[[NSMutableDictionary alloc] init] autorelease];
        for(id obj in dataArr){
            [tempArr addObject:[self makeAProgress:[obj[@"v"] doubleValue] max:1 frame:CGRectMake(x,n*15+2, 165, 10) color:[colorArr objectAtIndex:n]]];
            [tempGrade2Dic setObject:obj[@"v"] forKey:obj[@"y"]];
            n++;
        }
        [cellValueDic setObject:tempGrade2Dic forKey:className];
    }
    
}

-(AMProgressView *)makeAProgress:(float)current max:(float)max frame:(CGRect)rect color:(UIColor *)color{
    
    AMProgressView *am=[[[AMProgressView alloc] initWithFrame:rect
                                            andGradientColors:[NSArray arrayWithObjects:color, nil]
                                             andOutsideBorder:NO
                                                  andVertical:NO] autorelease];
    
    am.emptyPartAlpha = 1.0f;
    am.minimumValue=0;
    am.maximumValue=max;
    am.progress=current;
    return am;
}










- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end