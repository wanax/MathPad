//
//  FinancalModelRightListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinancalModelContainerViewController.h"
#import "ChartLeftListViewController.h"

@interface FinancalModelRightListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FinancalContainerDelegate,ChartLeftListDelegate>

@property (nonatomic,retain) UITableView *cusTable;

@property (nonatomic,retain) NSArray *classArr;
@property (nonatomic,retain) NSArray *barChartArr;
@property (nonatomic,retain) NSMutableDictionary *indexPathDic;

- (id)initWithClassDic:(NSDictionary *)classDic comInfo:(id)comInfo jsonData:(id)jsonData;

@end
