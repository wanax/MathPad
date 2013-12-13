//
//  ComInfoListColumn4.m
//  MathMonsters
//
//  Created by Xcode on 13-11-25.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComInfoListColumn4.h"
#import "ValueModelIndicator4.h"
#import "ValueModelCell4.h"
#import "AMProgressView.h"
#import "ComContainerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ComInfoListColumn4 ()

@property (nonatomic,retain) NSArray *discountRates;

@end

@implementation ComInfoListColumn4

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
    
    ValueModelIndicator4 *indicator=[[[ValueModelIndicator4 alloc] initWithFrame:CGRectMake(0,0, 790, 60)] autorelease];
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

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath{
    ValueModelCell4 *c=(ValueModelCell4 *)cell;
    [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack3"]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueModelCell4Identifier = @"ValueModelCell4Identifier";
    ValueModelCell4 *cell = (ValueModelCell4 *)[tableView dequeueReusableCellWithIdentifier:ValueModelCell4Identifier];
    if (cell == nil) {
        cell=[[[ValueModelCell4 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ValueModelCell4Identifier] autorelease];
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
        NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
        [formatter setPositiveFormat:@"0.00%;0.00%;-0.00%"];
        [cell discountRateLabel].text=[formatter stringFromNumber:self.discountRates[indexPath.row]];
        cell.contentView.backgroundColor=[Utiles colorWithHexString:@"#452A21"];
    }
    return cell;
}

-(void)setCell:(ValueModelCell4 *)cell classDic:(NSDictionary *)dic{

    [self setCellProcess:cell yearValueDic:dic[@"current ratio"] yearLableArr:[NSArray arrayWithObjects:cell.row00,cell.row10,cell.row20,cell.row30, nil] valueLable:[NSArray arrayWithObjects:cell.row01,cell.row11,cell.row21,cell.row31, nil] x:55];

}

-(void)setCellProcess:(ValueModelCell4 *)cell yearValueDic:(id)dic yearLableArr:(NSArray *)labels1 valueLable:(NSArray *)labels2 x:(int)x{
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };

    if (![dic isKindOfClass:[NSNull class]]) {
        int n=0;
        NSArray *keys=[[dic allKeys] sortedArrayUsingComparator:cmptr];
        for(id key in keys){
            UILabel *label= labels1[n];
            [label setText:[NSString stringWithFormat:@"20%@",key]];
            label=labels2[n];
            [label setText:[NSString stringWithFormat:@"%.2f",[dic[key] floatValue]]];
            n++;
        }
    }
}

#pragma mark -
#pragma TableCell Data Source

-(void)produceProgressForTable{
    
    NSArray *colorArr=[NSArray arrayWithObjects:[Utiles colorWithHexString:@"#fd9e1b"],[Utiles colorWithHexString:@"#f60933"],[Utiles colorWithHexString:@"#03d234"],[Utiles colorWithHexString:@"#0db4b4"], nil];
    
    NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *tempYearValueArr=[[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *tempDiscountRates=[[[NSMutableArray alloc] init] autorelease];
    for(id obj in self.progressArr){
        [temp addObject:obj];
    }
    for(id obj in self.yearValueArr){
        [tempYearValueArr addObject:obj];
    }
    for (id obj in self.discountRates) {
        [tempDiscountRates addObject:obj];
    }
    for(id comInfo in self.comList){
        NSMutableArray *tempGrade2=[[[NSMutableArray alloc] init] autorelease];
        NSMutableDictionary *cellValueDic=[[[NSMutableDictionary alloc] init] autorelease];
        
        [self produceProgressForClass:comInfo[@"data"] className:@"current ratio" tempGrade2:tempGrade2 cellValueDic:cellValueDic color:colorArr x:55];
        [tempDiscountRates addObject:comInfo[@"data"][@"discount rate"][@"array"][0][@"v"]];
        [temp addObject:tempGrade2];
        [tempYearValueArr addObject:cellValueDic];
    }
    self.discountRates=tempDiscountRates;
    self.progressArr=temp;
    self.yearValueArr=tempYearValueArr;
}

-(void)produceProgressForClass:(id)data className:(NSString *)className tempGrade2:(NSMutableArray *)tempArr cellValueDic:(NSMutableDictionary *)cellValueDic color:(NSArray *)colorArr x:(int)x{
    
    id classData=data[className];
    if (![classData isKindOfClass:[NSNull class]]) {
        NSMutableArray *hisClassDatas=[[[NSMutableArray alloc] init] autorelease];
        for (id obj in classData[@"array"]){
            if([obj[@"h"] boolValue]){
                [hisClassDatas addObject:obj];
            }
        }
        NSArray *dataArr=nil;
        if ([hisClassDatas count]>4) {
            NSMutableArray *temp=[NSMutableArray arrayWithCapacity:4];
            for(int i=[hisClassDatas count]-1,j=3;j>=0;j--,i--){
                [temp addObject:hisClassDatas[i]];
            }
            dataArr=[[temp reverseObjectEnumerator] allObjects];;
        } else {
            dataArr=hisClassDatas;
        }
        
        int n=0;
        //字典数组 生成cell年份-值label
        double max=0;
        for(id obj in dataArr){
            max+=[obj[@"v"] doubleValue];
        }
        NSMutableDictionary *tempGrade2Dic=[[[NSMutableDictionary alloc] init] autorelease];
        for(id obj in dataArr){
            [tempArr addObject:[self makeAProgress:[obj[@"v"] doubleValue] max:max frame:CGRectMake(x,n*15+2, 165, 10) color:[colorArr objectAtIndex:n]]];
            [tempGrade2Dic setObject:obj[@"v"] forKey:obj[@"y"]];
            n++;
        }
        [cellValueDic setObject:tempGrade2Dic forKey:className];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



















@end
