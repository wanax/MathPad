//
//  ComIconListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-20.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComIconListViewController.h"
#import "ComIconCell.h"
#import "ComInfoListColumn1.h"
#import "ComListController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ComIconListViewController ()

@end

@implementation ComIconListViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithMarkType:(MarketType)type
{
    self = [super init];
    if (self) {
        self.marketType=type;
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(comListDataLoaded)
                                                     name: @"ComListDataLoaded"
                                                   object: nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
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
    
    UITableView *temp=[[[UITableView alloc] initWithFrame:CGRectMake(0,60,130,600)] autorelease];
    self.iconTable=temp;
    self.iconTable.dataSource=self;
    self.iconTable.delegate=self;
    self.iconTable.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    self.iconTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.iconTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.iconTable];

}

-(void)comListDataLoaded{
    
    [self.iconTable reloadData];
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

    [cell.iconImg setImageWithURL:[NSURL URLWithString:self.comList[indexPath.row][@"info"][@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defaultIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (!image){
            [cell.comNameLabel setBackgroundColor:[UIColor whiteColor]];
            [cell.comNameLabel setText:self.comList[indexPath.row][@"info"][@"companyname"]];
            cell.comNameLabel.layer.cornerRadius=3.0;
        }
    }];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /*for(ComInfoListColumn *column in self.comTableArr){
        column.comTable.contentOffset=scrollView.contentOffset;
    }*/
    self.comListController.contentOffset=scrollView.contentOffset;
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
