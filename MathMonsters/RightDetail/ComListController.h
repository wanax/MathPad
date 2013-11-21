//
//  ComListController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-21.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComIconListViewController;

@interface ComListController : UIViewController<UIScrollViewDelegate>

@property MarketType marketType;
@property (nonatomic,retain) id comInfo;

@property (nonatomic,retain) ComIconListViewController *iconList;

- (id)initWithType:(MarketType)type iconList:(ComIconListViewController *)iconList;

@end
