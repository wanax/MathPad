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
#import "ClientCalendarListViewController.h"

@interface ClientCalendarViewController () <CKCalendarDelegate>

@property (nonatomic,retain) NSDateFormatter *formatter;
@property (nonatomic,retain) NSNumberFormatter *numFormatter;

@end

@implementation ClientCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDateFormatter *datefor = [[[NSDateFormatter alloc] init] autorelease];
        [datefor setDateFormat:@"yyyy-MM-dd"];
        self.formatter = datefor;
        
        NSNumberFormatter *numFor = [[[NSNumberFormatter alloc] init] autorelease];
        [numFor setPositiveFormat:@"00"];
        self.numFormatter = numFor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
    [self initComponents];
    
}

-(void)initComponents{
    
    CKCalendarView *cal = [[CKCalendarView alloc] initWithFrame:CGRectMake(10,50,500,800)];
    [self.view addSubview:cal];
    cal.delegate = self;
    self.calendar = cal;
    
    ClientCalendarListViewController *tableVC = [[[ClientCalendarListViewController alloc] init] autorelease];
    tableVC.view.frame = CGRectMake(520,10,430,1000);
    [self.view addSubview:tableVC.view];
    [self addChildViewController:tableVC];
    self.calendarEventsVC = tableVC;
    self.delegate = self.calendarEventsVC;
}

-(void)getClientCalendar:(NSDate *)date{
    
    
    NSDictionary *params = @{@"token":[Utiles getUserToken],
                             @"year":@([date year]),
                             @"month":@([date month]),
                             @"from":@"googuu"
                             };
    [Utiles postNetInfoWithPath:@"UserStockCalendar" andParams:params besidesBlock:^(id resObj){
        if(![[resObj objectForKey:@"status"] isEqualToString:@"0"]){
            
            NSMutableArray *temp = [[[NSMutableArray alloc] init] autorelease];
            for (id obj in resObj[@"data"]) {
                [temp addObject:[NSString stringWithFormat:@"%@-%@-%@",@([date year]),[self.numFormatter stringFromNumber:@([date month])],[self.numFormatter stringFromNumber:@([obj[@"day"] integerValue])]]];
            }
            self.eventsDates = temp;
            [self.calendar reloadData];
            
            NSMutableDictionary *tempDic = [[[NSMutableDictionary alloc] init] autorelease];
            for (id obj in resObj[@"data"]) {
                [tempDic setObject:obj[@"data"] forKey:[NSString stringWithFormat:@"%@-%@-%@",@([date year]),[self.numFormatter stringFromNumber:@([date month])],[self.numFormatter stringFromNumber:@([obj[@"day"] integerValue])]]];
            }
            self.calendarEventsVC.eventDates = [Utiles sortDateArr:[tempDic allKeys]];
            self.calendarEventsVC.eventDic = tempDic;
            [self.calendarEventsVC.calendarTable reloadData];
            
        }else{
            [Utiles ToastNotification:[resObj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}


#pragma mark -
#pragma mark - CKCalendarDelegate
- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date{
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date{
    [self getClientCalendar:date];
}

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    
    if ([self.eventsDates containsObject:[self.formatter stringFromDate:date]]) {
        dateItem.backgroundColor = [UIColor sunflowerColor];
    }
    
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    [self.delegate dateIsSelected:[self.formatter stringFromDate:date]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
