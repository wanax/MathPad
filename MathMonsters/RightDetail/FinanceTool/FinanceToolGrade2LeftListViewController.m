//
//  FinanceToolGrade2LeftListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-4.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinanceToolGrade2LeftListViewController.h"
#import "CounterViewController.h"
#import "CounterBankViewController.h"

@interface FinanceToolGrade2LeftListViewController ()

@end

@implementation FinanceToolGrade2LeftListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backPressed: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
}

-(void)initComponents{
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed:)];
    self.navigationItem.leftBarButtonItem = btn;
    [btn release];
    
    UITableView *t=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,324,920) style:UITableViewStyleGrouped] autorelease];
    self.customTabel=t;
    self.customTabel.dataSource=self;
    self.customTabel.delegate=self;
    self.customTabel.backgroundView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.customTabel];
    
}

#pragma mark -
#pragma Table DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.typeNames count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[self.customTabel dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.font=[UIFont fontWithName:@"Heiti SC" size:15.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setText:[self.typeNames objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark -
#pragma Table Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger type=[[self.types objectAtIndex:indexPath.row] integerValue];
    if(type==HSBC||type==BOC||type==SC){
        CounterBankViewController *counter=[[[CounterBankViewController alloc] init] autorelease];
        counter.params=[self.paramArr objectAtIndex:indexPath.row];
        counter.toolType=type;
        counter.title=[[[tableView  cellForRowAtIndexPath:indexPath] textLabel] text];
        counter.modalPresentationStyle=UIModalPresentationPageSheet;
        [self presentViewController:counter animated:YES completion:nil];
//        [self.customTabel deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        [self.delegate grade2Changed:[self.paramArr objectAtIndex:indexPath.row] title:[[[tableView  cellForRowAtIndexPath:indexPath] textLabel] text] type:type];
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
