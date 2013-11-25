//
//  ComListController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  估值模型右侧滑动table控制器

#import <UIKit/UIKit.h>


@class ComIconListViewController;

@interface ComListController : UIViewController<UIScrollViewDelegate>

@property CGPoint contentOffset;
@property MarketType marketType;
@property (nonatomic,retain) NSString *updateTime;
@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id comList;
@property (nonatomic,retain) NSArray *modelColumnArr;

@property (nonatomic,retain) ComIconListViewController *iconTableVC;

- (id)initWithType:(MarketType)type iconTableVC:(ComIconListViewController *)iconTableVC;

@end
