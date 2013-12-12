//
//  ClientCalendarListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-12-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientCalendarViewController.h"

@interface ClientCalendarListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ClientCalendarDelegate>

@property (nonatomic,retain) UITableView *calendarTable;

@property (nonatomic,retain) NSDictionary *eventDic;
@property (nonatomic,retain) NSArray *eventDates;

@end
