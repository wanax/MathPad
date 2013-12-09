//
//  ComInfoListColumn1.m
//  MathMonsters
//
//  Created by Xcode on 13-11-20.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComInfoListColumn1.h"
#import "ValueModelIndicator.h"
#import "ValueModelCell.h"
#import "AMProgressView.h"
#import "ComContainerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ComInfoListColumn1 ()

@end

@implementation ComInfoListColumn1



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
    
    ValueModelIndicator *indicator=[[[ValueModelIndicator alloc] initWithFrame:CGRectMake(0,0, 790, 60)] autorelease];
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
    ValueModelCell *c=(ValueModelCell *)cell;
    if (indexPath.row%2==0) {
        [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack"]];
    } else {
        [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack3"]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ValueModelCellIdentifier = @"ValueModelCellIdentifier";
    ValueModelCell *cell = (ValueModelCell*)[tableView dequeueReusableCellWithIdentifier:ValueModelCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ValueModelCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    if(self.comList){
        id comInfo=[self.comList objectAtIndex:indexPath.row][@"info"];
        cell.comTitleLabel.text=[comInfo objectForKey:@"companyname"]==nil?@"":[NSString stringWithFormat:@"%@\n(%@.%@)",[comInfo objectForKey:@"companyname"],[comInfo objectForKey:@"stockcode"],[comInfo objectForKey:@"marketname"]];

        [cell.saveImg setImage:[UIImage imageNamed:@"unsavemodel"]];
        [cell.concernImg setImage:[UIImage imageNamed:@"unconcernmodel"]];
        
        NSNumber *gPriceStr=[comInfo objectForKey:@"googuuprice"];
        float g=[gPriceStr floatValue];
        NSNumber *priceStr=[comInfo objectForKey:@"marketprice"];
        float p = [priceStr floatValue];
        float outLook=(g-p)/p;
        cell.outLookLabel.text=[NSString stringWithFormat:@"%.2f%%",outLook*100];
        if (outLook<0) {
            [cell.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#BA0020"]];
            [cell.outLookImg setImage:[UIImage imageNamed:@"down"]];
        } else {
            [cell.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#36871A"]];
            [cell.outLookImg setImage:[UIImage imageNamed:@"riseup"]];
        }
        
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
        cell.markPriLabel.text=[NSString stringWithFormat:@"%.2f",p];
        cell.googuuPriLabel.text=[NSString stringWithFormat:@"%.2f",g];
        
    }
    
    return cell;
}

-(void)produceProgressForTable{
    
    NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
    for(id obj in self.progressArr){
        [temp addObject:obj];
    }
    for(id comInfo in self.comList){
        NSMutableArray *tempGrade2=[[[NSMutableArray alloc] init] autorelease];
        float g=[comInfo[@"info"][@"googuuprice"] floatValue];
        float p = [comInfo[@"info"][@"marketprice"] floatValue];
        [tempGrade2 addObject:[self makeAProgress:p max:p+g frame:CGRectMake(390,8,180,18) color:[UIColor orangeColor]]];
        [tempGrade2 addObject:[self makeAProgress:g max:p+g frame:CGRectMake(390,34,180,18) color:[UIColor purpleColor]]];
        [temp addObject:tempGrade2];
    }
    self.progressArr=temp;
}















- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
