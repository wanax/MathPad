//
//  ClientCalendarListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-12-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ClientCalendarListViewController.h"

@interface ClientCalendarListViewController ()

@end

@implementation ClientCalendarListViewController

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


-(void)initComponents {
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,390,630)] autorelease];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.calendarTable = tableView;
    
}
#pragma mark -
#pragma ClientCalendar Methods Delegate

-(void)dateIsSelected:(NSString *)date {
    
    int n=0;
    while (n<[self.eventDates count]) {
        if ([self.eventDates[n] isEqualToString:date]) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:n];
            [self.calendarTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        n++;
    }
}

#pragma mark -
#pragma Table Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.eventDates count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventDic[self.eventDates[section]] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.eventDates[section];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CalendarCellIdentifier = @"CalendarCellIdentifier";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CalendarCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CalendarCellIdentifier] autorelease];
    }
    
    id model = self.eventDic[self.eventDates[indexPath.section]][indexPath.row];
    cell.textLabel.text = model[@"companyname"];
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:17.0];
    cell.detailTextLabel.text = model[@"desc"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    return cell;
}

#pragma mark -
#pragma Table Methods Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id model = self.eventDic[self.eventDates[indexPath.section]][indexPath.row];
    [Utiles showToastView:self.parentViewController.view withTitle:model[@"companyname"] andContent:model[@"desc"] duration:1.5];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}










- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
