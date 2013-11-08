//
//  ViewController.h
//  ExpansionTableView
//
//  Created by JianYe on 13-2-18.
//  Copyright (c) 2013年 JianYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinancalModelChartViewController.h"

@interface FinancalModelLeftListViewController : UIViewController<FinancalDataDelegate>

@property (assign)BOOL isOpen;

@property (nonatomic,retain) NSMutableArray *dataList;
@property (nonatomic,retain) id transData;
@property (nonatomic,retain) NSArray *sectionKeys;
@property (nonatomic,retain) NSIndexPath *selectIndex;
@property (nonatomic,retain) UITableView *expansionTableView;

@end
