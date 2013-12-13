//
//  ComInfoListColumn3.m
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComInfoListColumn3.h"
#import "ValueModelIndicator3.h"
#import "ValueModelCell2.h"
#import "AMProgressView.h"
#import "ComContainerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ComInfoListColumn3 ()

@end

@implementation ComInfoListColumn3

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
    
    ValueModelIndicator3 *indicator=[[[ValueModelIndicator3 alloc] initWithFrame:CGRectMake(0,0, 790, 60)] autorelease];
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
    ValueModelCell2 *c=(ValueModelCell2 *)cell;
    [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack3"]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueModelCell2Identifier = @"ValueModelCell2Identifier";
    ValueModelCell2 *cell = (ValueModelCell2 *)[tableView dequeueReusableCellWithIdentifier:ValueModelCell2Identifier];
    if (cell == nil) {
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
    
    [self setCellProcess:cell yearValueDic:dic[@"net margin"] yearLableArr:[NSArray arrayWithObjects:cell.row00,cell.row10,cell.row20,cell.row30, nil] valueLable:[NSArray arrayWithObjects:cell.row01,cell.row11,cell.row21,cell.row31, nil] x:55];
    
    [self setCellProcess:cell yearValueDic:dic[@"roic"] yearLableArr:[NSArray arrayWithObjects:cell.row02,cell.row12,cell.row22,cell.row32, nil] valueLable:[NSArray arrayWithObjects:cell.row03,cell.row13,cell.row23,cell.row33, nil] x:310];
    
    [self setCellProcess:cell yearValueDic:dic[@"roe"] yearLableArr:[NSArray arrayWithObjects:cell.row04,cell.row14,cell.row24,cell.row34, nil] valueLable:[NSArray arrayWithObjects:cell.row05,cell.row15,cell.row25,cell.row35, nil] x:570];
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
        
        [self produceProgressForClass:comInfo[@"data"] className:@"net margin" tempGrade2:tempGrade2 cellValueDic:cellValueDic color:colorArr x:55];
        [self produceProgressForClass:comInfo[@"data"] className:@"roic" tempGrade2:tempGrade2 cellValueDic:cellValueDic color:colorArr x:310];
        [self produceProgressForClass:comInfo[@"data"] className:@"roe" tempGrade2:tempGrade2 cellValueDic:cellValueDic color:colorArr x:570];
        
        [temp addObject:tempGrade2];
        [tempYearValueArr addObject:cellValueDic];
    }
    self.progressArr=temp;
    self.yearValueArr=tempYearValueArr;
}









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
