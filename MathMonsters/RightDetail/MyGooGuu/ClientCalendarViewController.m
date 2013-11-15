//
//  ClientCalendarViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ClientCalendarViewController.h"
#import "NSDate+convenience.h"
#import "CKCalendarView.h"
#import "FlatUIKit.h"

@interface ClientCalendarViewController () <CKCalendarDelegate>

@property(nonatomic, strong) NSArray *disabledDates;

@end

@implementation ClientCalendarViewController

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
	[self.view setBackgroundColor:[UIColor midnightBlueColor]];
    [self initComponents];
    
}

-(void)initComponents{
    self.cusTable=[[UITableView alloc] initWithFrame:CGRectMake(12,80,900,450)];
    self.cusTable.dataSource=self;
    self.cusTable.delegate=self;
    self.cusTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.cusTable.backgroundColor=[UIColor midnightBlueColor];
    [self.view addSubview:self.cusTable];
    
    NSMutableArray *calTemp=[[NSMutableArray alloc] init];
    for(int i=1;i<=12;i++){
        [calTemp addObject:[self newAcalendar:[NSString stringWithFormat:@"2013-0%d-01",i]]];
    }
    self.calArr=calTemp;
    SAFE_RELEASE(calTemp);
    
    NSDateFormatter *formatter=[[[NSDateFormatter alloc] init] autorelease];
    self.monArrEn=[formatter shortMonthSymbols];
    self.monArrCn=@[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月",];
    
}

-(CKCalendarView *)newAcalendar:(NSString *)date {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
    calendar.delegate = self;
    
    [calendar setDateFont:[UIFont fontWithName:@"Heiti SC" size:20.0]];
    [calendar setDateFont:[UIFont boldSystemFontOfSize:20.0]];
    
    self.disabledDates = @[
                           [Utiles dateFromString:@"2013-05-08"],
                           [Utiles dateFromString:@"2013-07-06"],
                           [Utiles dateFromString:@"2013-12-22"]
                           ];
    
    calendar.onlyShowCurrentMonth = YES;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    [calendar setMonthShowing:[Utiles dateFromString:date]];
    
    return [calendar autorelease];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 310.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.contentView.backgroundColor=[UIColor midnightBlueColor];
    
    for(UIView *view in [cell.contentView subviews]){
        if([view isKindOfClass:NSClassFromString(@"UILabel")]){
            [view removeFromSuperview];
        }
    }
    
    void (^configureCell)(int,CGRect,CGRect,CGRect)=^(int index,CGRect frame,CGRect l1,CGRect l2){
        
        
        CKCalendarView *calView=[self.calArr objectAtIndex:(index)];
        calView.frame=frame;
        [cell.contentView addSubview:calView];
        
        UILabel *indicatorEn=[[[UILabel alloc] init] autorelease];
        UILabel *indicatorCn=[[[UILabel alloc] init] autorelease];
        [indicatorEn setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
        [indicatorCn setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
        [indicatorCn setText:[self.monArrCn objectAtIndex:(index)]];
        [indicatorCn setTextAlignment:NSTextAlignmentRight];
        [indicatorEn setText:[self.monArrEn objectAtIndex:(index)]];
        [indicatorCn setFrame:l2];
        [indicatorEn setFrame:l1];
        [cell.contentView addSubview:indicatorEn];
        [cell.contentView addSubview:indicatorCn];
    };
    
    configureCell((3*indexPath.row),CGRectMake(11,40, 285, 182),CGRectMake(11,0,50,40),CGRectMake(230,0,60,40));
    configureCell((3*indexPath.row+1),CGRectMake(308,40, 285, 182),CGRectMake(308,0,50,40),CGRectMake(530,0,60,40));
    configureCell((3*indexPath.row+2),CGRectMake(603,40, 285, 182),CGRectMake(603,0,50,40),CGRectMake(820,0,60,40));
    
    return cell;
}


- (void)localeDidChange {
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backImg=[UIImage imageNamed:@"3"];
    }
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
