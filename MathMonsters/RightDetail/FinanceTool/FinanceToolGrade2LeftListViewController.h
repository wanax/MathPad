//
//  FinanceToolGrade2LeftListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-4.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftToolGrade2ListDelegate <NSObject>
@optional
-(void)grade2Changed:(NSDictionary *)params title:(NSString *)title type:(FinancalToolsType)type;
@end

@interface FinanceToolGrade2LeftListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSArray *typeNames;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSArray *paramArr;

@property (nonatomic,retain) UITableView *customTabel;

@property (nonatomic,retain) id<LeftToolGrade2ListDelegate> delegate;

@end
