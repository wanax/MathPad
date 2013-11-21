//
//  ComIconListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-20.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComIconListViewController.h"
#import "ComIconCell.h"
#import "ComInfoListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ComIconListViewController ()

@end

@implementation ComIconListViewController

- (id)initWithMarkType:(MarketType)type
{
    self = [super init];
    if (self) {
        self.marketType=type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
    [self addCompanyIconUrl];
}

-(void)initComponents{
    
    self.view.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    
    UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(0,0,130,60)] autorelease];
    [label setText:@"上市公司"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[Utiles colorWithHexString:@"#291912"]];
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:18]];
    [label setTextColor:[Utiles colorWithHexString:@"#e6cbc0"]];
    [self.view addSubview:label];
    
    UITableView *temp=[[[UITableView alloc] initWithFrame:CGRectMake(0,60,130,655)] autorelease];
    self.iconTable=temp;
    self.iconTable.dataSource=self;
    self.iconTable.delegate=self;
    self.iconTable.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    self.iconTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.iconTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.iconTable];
    
}

-(void)addCompanyIconUrl{

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.marketType],@"market",self.updateTime,@"updatetime", nil];
    [Utiles getNetInfoWithPath:@"QueryIpadAllCompany" andParams:params besidesBlock:^(id resObj){
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in self.comList){
            [temp addObject:obj];
        }
        for (id data in resObj) {
            [temp addObject:data[@"info"]];
        }
        self.comList=temp;
        [self.iconTable reloadData];
        self.updateTime=[[self.comList lastObject] objectForKey:@"updatetime"];
       
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

#pragma mark -
#pragma mark Table Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath{
    ComIconCell *c=(ComIconCell *)cell;
    if (indexPath.row%2==0) {
        [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack"]];
    } else {
        [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack3"]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ComIconCellIdentifier = @"ComIconCellIdentifier";
    ComIconCell *cell = (ComIconCell*)[tableView dequeueReusableCellWithIdentifier:ComIconCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ComIconCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    [cell.iconImg setImageWithURL:[NSURL URLWithString:[[self.comList objectAtIndex:indexPath.row] objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.comInfoList.cusTabView.contentOffset=scrollView.contentOffset;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
