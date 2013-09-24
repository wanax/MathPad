//
//  PopListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *cusTable;

@property (nonatomic,retain) NSArray *fonts;
@property (copy,nonatomic) NSString *selectedFontName;
@property (nonatomic,assign) UIPopoverController *container;

@end
