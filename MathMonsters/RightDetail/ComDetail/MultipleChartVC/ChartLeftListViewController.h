//
//  ViewController.h
//  ExpansionTableView
//
//  Created by JianYe on 13-2-18.
//  Copyright (c) 2013年 JianYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartLeftListViewController.h"
#import "ValueModelChartDelegate.h"
#import "ChartLeftListDelegate.h"


@interface ChartLeftListViewController : UIViewController<ValueModelChartDelegate>

@property (assign)BOOL isOpen;
@property ChartType type;
@property (nonatomic,retain) id<ChartLeftListDelegate> delegate;
@property (nonatomic,retain) id transData;
@property (nonatomic,retain) NSArray *sectionKeys;
@property (nonatomic,retain) NSArray *savedRowItems;
@property (nonatomic,retain) NSArray *rowItems;
@property (nonatomic,retain) NSDictionary *sectionDic;
@property (nonatomic,retain) NSIndexPath *selectIndex;
@property (nonatomic,retain) UITableView *expansionTableView;

@end
