//
//  ComIconListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-20.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComListController;

@interface ComIconListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property MarketType marketType;
@property (nonatomic,retain) NSString *updateTime;
@property (nonatomic,retain) NSArray *comList;

@property (nonatomic,retain) UITableView *iconTable;
@property (nonatomic,retain) NSArray *comTableArr;

@property (nonatomic,retain) ComListController *comListController;

- (id)initWithMarkType:(MarketType)type;

@end
