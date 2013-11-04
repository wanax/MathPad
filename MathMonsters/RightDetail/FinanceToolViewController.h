//
//  FinanceToolViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinanceToolLeftListViewController.h"

@class CounterViewController;

@interface FinanceToolViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LeftToolListDelegate>

@property (nonatomic,retain) UITableView *cusTable;

@property (nonatomic,retain) CounterViewController *detail;

@end
