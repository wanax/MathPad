//
//  MyGooGuuViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientRelationStockListViewController;
@class ClientCalendarViewController;
@class MHTabBarController;


@interface MyGooGuuViewController : UIViewController

@property (nonatomic,retain) ClientRelationStockListViewController *concernedListViewController;
@property (nonatomic,retain) ClientRelationStockListViewController *savedListViewControler;
@property (nonatomic,retain) ClientCalendarViewController *calendarViewController;
@property (nonatomic,retain) MHTabBarController* tabBarController;

@end
