//
//  SearchComListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-12-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "SearchComListViewController.h"
#import "ComContainerViewController.h"
#import "NewReportArticleViewController.h"

@interface SearchComListViewController ()

@end

@implementation SearchComListViewController

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
    UITableView *tView=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,800,450)] autorelease];
    tView.backgroundColor=[UIColor whiteColor];
    tView.showsVerticalScrollIndicator=NO;
    tView.delegate=self;
    tView.dataSource=self;
    //tView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.comTable=tView;
    [self.view addSubview:self.comTable];
}


#pragma mark -
#pragma Table DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.companys count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ComCellIdentifier = @"ComCellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ComCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ComCellIdentifier] autorelease];
    }
    
    if (self.companys) {
        id model = self.companys[indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@(%@.%@)",model[@"companyname"],model[@"stockcode"],model[@"market"]];
    }
    
    return cell;
    
}


#pragma mark -
#pragma mark Table Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.companys[indexPath.row][@"hasmodel"] boolValue]) {
        ComContainerViewController *comContainerVC=[[[ComContainerViewController alloc] init] autorelease];
        UINavigationController *comNav=[[[UINavigationController alloc] initWithRootViewController:comContainerVC] autorelease];
        comContainerVC.comInfo=self.companys[indexPath.row];
        [self presentViewController:comNav animated:YES completion:nil];
    } else if ([self.companys[indexPath.row][@"hasreport"] boolValue]){
        NewReportArticleViewController *reportArticleVC=[[[NewReportArticleViewController alloc] init] autorelease];
        UINavigationController *reportNav=[[[UINavigationController alloc] initWithRootViewController:reportArticleVC] autorelease];
        reportArticleVC.comInfo=self.companys[indexPath.row];
        [self presentViewController:reportNav animated:YES completion:nil];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"oooooops 什么都没有" duration:1.0];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
