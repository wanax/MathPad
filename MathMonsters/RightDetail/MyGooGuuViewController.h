//
//  MyGooGuuViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"

@interface MyGooGuuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *cusTable;

@property (nonatomic,retain) NSArray *calArr;
@property (nonatomic,retain) NSArray *monArrEn;
@property (nonatomic,retain) NSArray *monArrCn;

@end
