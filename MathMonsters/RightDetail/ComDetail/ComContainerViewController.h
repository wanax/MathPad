//
//  ComContainerViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTabBarController;
@class ValuationModelContainerViewController;
@class FinancalModelContainerViewController;
@class DahonValuationViewController;
@class MyProLossContainerViewController;

@interface ComContainerViewController : UIViewController{
    BOOL _firstLaunch;
}

@property BrowseSourceType sourceType;

@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) UIViewController *detailViewController;

@property (nonatomic,retain) ValuationModelContainerViewController *valueContainer;
@property (nonatomic,retain) FinancalModelContainerViewController *finContainer;
@property (nonatomic,retain) DahonValuationViewController *dahonContainer;
@property (nonatomic,retain) MyProLossContainerViewController *myProLossContainer;
@property (nonatomic,retain) MHTabBarController* tabBarController;












@end
