//
//  DailyRightListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-18.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DailyRightListViewController.h"
#import "ComContainerViewController.h"
#import "MHTabBarController.h"
#import "ValueModelChartViewController.h"
#import "FinancalModelChartViewController.h"

@interface DailyRightListViewController ()

@end

@implementation DailyRightListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSDictionary *)data driverIds:(NSArray *)ids
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.valueIncomeDic=data;
        self.driverIds=ids;
        self.valueArr=[self.valueIncomeDic allKeys];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
}

-(void)initComponents{
    UITableView *temp=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,400,570)] autorelease];
    temp.dataSource=self;
    temp.delegate=self;
    temp.separatorStyle=UITableViewCellSeparatorStyleNone;
    temp.backgroundColor=[UIColor peterRiverColor];
    self.dailyTable=temp;
    [self.view addSubview:self.dailyTable];
}

#pragma mark -
#pragma mark Table Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.driverIds count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.dailyTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    FinancalModelChartViewController *chartView=[[[FinancalModelChartViewController alloc] init] autorelease];
    chartView.comInfo=self.comInfo;
    chartView.jsonForChart=self.jsonForChart;
    NSLog(@"%@",[self.driverIds objectAtIndex:indexPath.row]);
    chartView.driverId=[self.driverIds objectAtIndex:indexPath.row];
    [cell.contentView addSubview:chartView.view];
    [self addChildViewController:chartView];
    return cell;
}

#pragma mark -
#pragma mark Table Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ComContainerViewController *comContainerVC=[[[ComContainerViewController alloc] init] autorelease];
    UINavigationController *comNav=[[[UINavigationController alloc] initWithRootViewController:comContainerVC] autorelease];
    comContainerVC.comInfo=self.comInfo;
    id driverId=[[self.valueIncomeDic objectForKey:[self.valueArr objectAtIndex:indexPath.row]] objectForKey:@"identifier"];
    [self presentViewController:comNav animated:YES completion:nil];
    [(MHTabBarController *)comContainerVC.tabBarController setSelectedIndex:2];
    ((ValueModelChartViewController *)comContainerVC.valueContainer.rightListVC).globalDriverId=driverId;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
