//
//  FinanceToolLeftListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-1.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinanceToolLeftListViewController.h"

@interface FinanceToolLeftListViewController ()

@end

@implementation FinanceToolLeftListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initComponents];
}

-(void)initComponents{
    
    
    self.cusTable=[[UITableView alloc] initWithFrame:CGRectMake(0,0,184,568)];
    self.cusTable.dataSource=self;
    self.cusTable.delegate=self;
    [self.cusTable setBackgroundColor:[UIColor purpleColor]];
    self.cusTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cusTable];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
    }
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    cell.textLabel.text=@"test";
    [cell.imageView setImage:[UIImage imageNamed:@"BETA"]];
    [cell.contentView setBackgroundColor:[UIColor orangeColor]];
    
    return cell;
}

#pragma mark -
#pragma mark Table Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FinanceToolLeftListViewController *test=[[FinanceToolLeftListViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
