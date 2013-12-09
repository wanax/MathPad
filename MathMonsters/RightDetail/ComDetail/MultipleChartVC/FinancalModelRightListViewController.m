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

- (id)initWithClassDic:(NSDictionary *)classDic comInfo:(id)comInfo jsonData:(id)jsonData
{
    self = [super init];
    if (self) {
        NSMutableDictionary *temp=[[[NSMutableDictionary alloc] init] autorelease];
        self.indexPathDic=temp;
        
        NSMutableArray *tempArr=[[[NSMutableArray alloc] init] autorelease];
        for(id key in classDic){
            for(id obj in [classDic objectForKey:key]){
                [tempArr addObject:obj];
            }
        }
        self.classArr=tempArr;
        
        NSMutableArray *temp2Arr=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in self.classArr){
            FinancalModelChartViewController *chartView=[[[FinancalModelChartViewController alloc] init] autorelease];
            chartView.comInfo=comInfo;
            chartView.jsonForChart=jsonData;
            chartView.driverId=[obj objectForKey:@"id"];
            [temp2Arr addObject:chartView];
        }
        self.barChartArr=temp2Arr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
}

-(void)initComponents{
    
    UITableView *tView=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,680,610)] autorelease];
    tView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tView.dataSource=self;
    tView.delegate=self;
    self.cusTable=tView;
    [self.view addSubview:self.cusTable];
    
}
#pragma mark -
#pragma mark FinancalContainer Delegate

-(void)rightListClassChanged{
    
    
    for(int n=0;n<[self.classArr count];n++){
        [self.indexPathDic setObject:[NSNumber numberWithInt:n] forKey:[[self.classArr objectAtIndex:n] objectForKey:@"id"]];
    }
    [self.cusTable reloadData];
}

#pragma mark -
#pragma mark ChartLeftListDelegate
-(void)modelChanged:(NSString *)driverId{
    
    NSIndexPath *index=[NSIndexPath indexPathForRow:[[self.indexPathDic objectForKey:driverId] integerValue] inSection:0];
    [self.cusTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    return 280.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.cusTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    FinancalModelChartViewController *chartView=[self.barChartArr objectAtIndex:indexPath.row];
    [cell.contentView addSubview:chartView.view];
    [self addChildViewController:chartView];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
