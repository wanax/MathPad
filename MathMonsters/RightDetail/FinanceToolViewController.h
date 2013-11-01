//
//  FinanceToolViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceToolViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *cusTable;

@end
