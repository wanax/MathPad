//
//  FinancalModelContainerViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartLeftListViewController;
@class FinancalModelRightListViewController;

@protocol FinancalContainerDelegate <NSObject>
@optional
-(void)rightListClassChanged;
@end

@interface FinancalModelContainerViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) ChartLeftListViewController *leftListVC;
@property (nonatomic,retain) FinancalModelRightListViewController *rightListVC;

@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id jsonForChart;
@property (nonatomic,retain) id<FinancalContainerDelegate> delegate;

@end
