//
//  DailyRightListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-18.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieViewController.h"

@interface DailyRightListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PieViewDelegate>

@property (nonatomic,retain) NSDictionary *valueIncomeDic;
@property (nonatomic,retain) NSDictionary *classToChildIds;
@property (nonatomic,retain) NSArray *valueArr;
@property (nonatomic,retain) NSArray *barChartArr;
@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id driverIds;
@property (nonatomic,retain) id jsonData;

@property (nonatomic,retain) UITableView *dailyTable;

- (id)initWithValueIncomeDic:(NSDictionary *)data driverIds:(NSArray *)ids jsonData:(id)jsonData comInfo:(id)comInfo;

@end
