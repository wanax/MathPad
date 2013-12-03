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
#import "DailyStockBarChartViewController.h"

@interface DailyRightListViewController ()

@end

@implementation DailyRightListViewController

- (id)initWithValueIncomeDic:(NSDictionary *)data driverIds:(NSArray *)ids jsonData:(id)jsonData comInfo:(id)comInfo
{
    self = [super init];
    if (self) {
        self.valueIncomeDic=data;
        self.driverIds=ids;
        self.valueArr=[self.valueIncomeDic allKeys];
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id driverId in self.driverIds){
            DailyStockBarChartViewController *chartView=[[[DailyStockBarChartViewController alloc] init] autorelease];
            chartView.comInfo=comInfo;
            chartView.jsonData=jsonData;
            chartView.driverId=driverId;
            [temp addObject:chartView];
        }
        self.barChartArr=temp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
}

-(void)initComponents{
    UITableView *temp=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,470,570)] autorelease];
    temp.dataSource=self;
    temp.delegate=self;
    temp.separatorStyle=UITableViewCellSeparatorStyleNone;
    temp.backgroundColor=[Utiles colorWithHexString:@"#FDFBE4"];
    self.dailyTable=temp;
    [self.view addSubview:self.dailyTable];
}

#pragma mark -
#pragma PieView Delegate

-(void)pieWasChoosen:(NSString *)className{
    
    int n=0;
    id driverId=self.classToChildIds[className][0];
    for(n=0;n<[self.driverIds count];n++){
        if([driverId equals:self.driverIds[n]]){
            NSIndexPath *index=[NSIndexPath indexPathForRow:n inSection:0];
            [self.dailyTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
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
    DailyStockBarChartViewController *chartView=[self.barChartArr objectAtIndex:indexPath.row];
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


- (BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
