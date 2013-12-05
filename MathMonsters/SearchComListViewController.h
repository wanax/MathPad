//
//  SearchComListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-12-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchComListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *comTable;

@property (nonatomic,retain) NSArray *companys;

@end
