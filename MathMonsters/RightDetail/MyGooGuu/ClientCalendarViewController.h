//
//  ClientCalendarViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClientCalendarDelegate <NSObject>
-(void)dateIsSelected:(NSString *)date;
@end

@class CKCalendarView;
@class ClientCalendarListViewController;

@interface ClientCalendarViewController : UIViewController

@property (nonatomic,retain) id<ClientCalendarDelegate> delegate;

@property (nonatomic,retain) NSArray *events;
@property (nonatomic,retain) NSArray *eventsDates;

@property (nonatomic,retain) ClientCalendarListViewController *calendarEventsVC;
@property (nonatomic,retain) CKCalendarView *calendar;

@end
