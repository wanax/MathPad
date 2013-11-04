//
//  FinanceToolLeftListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-1.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinanceToolGrade2LeftListViewController.h"

@protocol LeftToolListDelegate <NSObject>
@optional
-(void)toolChanged:(NSString *)pName pUnit:(NSString *)pUnit rName:(NSString *)rName rUnit:(NSString *)rUnit type:(FinancalToolsType)type;
@end

@interface FinanceToolLeftListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LeftToolGrade2ListDelegate>

@property (nonatomic,retain) id<LeftToolListDelegate> delegate;
@property (nonatomic,retain) UITableView *cusTable;

@end
