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
	[self.view setBackgroundColor:[UIColor emerlandColor]];
    [self initComponents];
    
}

-(void)initComponents{
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithFrame:CGRectMake(10,50,550,800)];
    [self.view addSubview:calendar];
    calendar.delegate = self;
    [self getClientCalendar:[NSDate date]];
}

-(void)getClientCalendar:(NSDate *)date{
    
    
    NSDictionary *params = @{@"token":[Utiles getUserToken],
                             @"year":@([date year]),
                             @"month":@([date month]),
                             @"from":@"googuu"
                             };
    NSLog(@"%@",params);
    [Utiles postNetInfoWithPath:@"UserStockCalendar" andParams:params besidesBlock:^(id resObj){
        if(![[resObj objectForKey:@"status"] isEqualToString:@"0"]){
            
            NSLog(@"%@",[resObj JSONString]);
            
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
    NSLog(@"%@",date);
    [self getClientCalendar:date];
}

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    //NSLog(@"%@",date);
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
