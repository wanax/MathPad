//
//  ComInfoListColumn2.m
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComInfoListColumn2.h"
#import "ValueModelIndicator2.h"
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

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath{
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueModelCellIdentifier = @"ValueModelCellIdentifier";
    ValueModelCell2 *cell = (ValueModelCell2*)[tableView dequeueReusableCellWithIdentifier:ValueModelCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ValueModelCell" owner:self options:nil];
        cell = [array objectAtIndex:1];
    }
    
    if(self.comList){
        id comData=[self.comList objectAtIndex:indexPath.row][@"data"];
        for(UIView *view in cell.contentView.subviews){
            if([view isKindOfClass:NSClassFromString(@"AMProgressView")]){
                [view removeFromSuperview];
            }
        }
        [self setCell:cell comData:comData];

        cell.contentView.backgroundColor=[Utiles colorWithHexString:@"#452A21"];
    }
    return cell;
}

-(void)setCell:(ValueModelCell2 *)cell comData:(id)comData{

    [self setCellProcess:cell data:comData[@"Revenue growth rate"] yearLableArr:[NSArray arrayWithObjects:cell.row00,cell.row10,cell.row20,cell.row30, nil] valueLable:[NSArray arrayWithObjects:cell.row01,cell.row11,cell.row21,cell.row31, nil] x:55];
    
    [self setCellProcess:cell data:comData[@"Net income growth rate"] yearLableArr:[NSArray arrayWithObjects:cell.row02,cell.row12,cell.row22,cell.row32, nil] valueLable:[NSArray arrayWithObjects:cell.row03,cell.row13,cell.row23,cell.row33, nil] x:310];
    
    [self setCellProcess:cell data:comData[@"Gross profit margin"] yearLableArr:[NSArray arrayWithObjects:cell.row04,cell.row14,cell.row24,cell.row34, nil] valueLable:[NSArray arrayWithObjects:cell.row05,cell.row15,cell.row25,cell.row35, nil] x:570];
}

-(void)setCellProcess:(ValueModelCell2 *)cell data:(id)data yearLableArr:(NSArray *)labels1 valueLable:(NSArray *)labels2 x:(int)x{
    
    NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    NSArray *colorArr=[NSArray arrayWithObjects:[Utiles colorWithHexString:@"#fd9e1b"],[Utiles colorWithHexString:@"#f60933"],[Utiles colorWithHexString:@"#03d234"],[Utiles colorWithHexString:@"#0db4b4"], nil];
    
    if (![data isKindOfClass:[NSNull class]]) {
        NSArray *dataArr=nil;
        if ([data[@"array"] count]>4) {
            NSMutableArray *temp=[NSMutableArray arrayWithCapacity:4];
            for(int i=[data[@"array"] count]-1,j=3;j>=0;j--,i--){
                [temp addObject:data[@"array"][i]];
            }
            dataArr=[[temp reverseObjectEnumerator] allObjects];;
        } else {
            dataArr=data[@"array"];
        }
        
        int n=0;
        for(id obj in dataArr){
            UILabel *label= labels1[n];
            [label setText:[NSString stringWithFormat:@"20%@",obj[@"y"]]];
            label=labels2[n];
            [label setText:[formatter stringFromNumber:obj[@"v"]]];
            
            AMProgressView *am=[[[AMProgressView alloc] initWithFrame:CGRectMake(x,n*15+2, 165, 10)
                                                    andGradientColors:[NSArray arrayWithObjects:[colorArr objectAtIndex:n], nil]
                                                     andOutsideBorder:NO
                                                          andVertical:NO] autorelease];
            
            am.emptyPartAlpha = 1.0f;
            am.minimumValue=0;
            am.maximumValue=1;
            am.progress=[obj[@"v"] doubleValue];
            [cell.contentView addSubview:am];
            n++;
        }
    }
}














- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
