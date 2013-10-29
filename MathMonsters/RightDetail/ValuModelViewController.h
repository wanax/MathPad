//
//  ValuModelViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValuModelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property MarketType marketType;

@property (nonatomic,retain) UITableView *cusTabView;

@property (nonatomic,retain) NSArray *comList;
@property (nonatomic,retain) NSMutableArray *concernStocksCodeArr;
@property (nonatomic,retain) NSString *updateTime;

@end
