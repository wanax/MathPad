//
//  FinancalModelRightListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinancalModelContainerViewController.h"

@interface FinancalModelRightListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FinancalContainerDelegate>

@property (nonatomic,retain) UITableView *cusTable;

@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id jsonForChart;
@property (nonatomic,retain) id classDic;
@property (nonatomic,retain) NSArray *classArr;

@end
