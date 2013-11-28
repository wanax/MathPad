//
//  ValuationModelContainerViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-11.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartLeftListViewController;
@class ValueModelChartViewController;

@protocol ValuationModelContainerDelegate <NSObject>
@optional
-(void)rightVCDataHasBeenLoaded;
@end

@interface ValuationModelContainerViewController : UIViewController<UIWebViewDelegate>

@property BrowseSourceType sourceType;

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) ChartLeftListViewController *leftListVC;
@property (nonatomic,retain) ValueModelChartViewController *rightListVC;

@property (nonatomic,retain) id<ValuationModelContainerDelegate> delegate;
@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id jsonForChart;

@end
