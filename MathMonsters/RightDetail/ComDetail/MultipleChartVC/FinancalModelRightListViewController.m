//
//  FinancalModelRightListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinancalModelRightListViewController.h"
#import "FinancalModelChartViewController.h"

@interface FinancalModelRightListViewController ()

@end

@implementation FinancalModelRightListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    UITableView *tView=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,650,610)] autorelease];
    //tView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tView.dataSource=self;
    tView.delegate=self;
    self.cusTable=tView;
    [self.view addSubview:self.cusTable];
    
}
#pragma mark -
#pragma mark FinancalContainer Delegate

-(void)rightListClassChanged{
    
    NSMutableArray *tempArr=[[[NSMutableArray alloc] init] autorelease];
    for(id key in self.classDic){
        for(id obj in [self.classDic objectForKey:key]){
            [tempArr addObject:obj];
        }
    }
    self.classArr=tempArr;
    [self.cusTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.classArr count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.cusTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    FinancalModelChartViewController *chartView=[[FinancalModelChartViewController alloc] init];
    chartView.comInfo=self.comInfo;
    chartView.jsonForChart=self.jsonForChart;
    chartView.driverId=[[self.classArr objectAtIndex:indexPath.row] objectForKey:@"id"];
    [cell.contentView addSubview:chartView.view];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
