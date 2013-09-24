//
//  RightViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontListViewController.h"
#import "PieChartView.h"


@interface RightViewController : UIViewController<UIPopoverControllerDelegate,UISplitViewControllerDelegate,FontListDelegate,PieChartDelegate>

@property (nonatomic,retain) UIFont *font;

@property (nonatomic,retain) UIPopoverController *currentPopover;
@property (nonatomic,retain) UILabel *lable;
@property (nonatomic,retain) UIToolbar *toolBar;

@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *valueArray2;
@property (nonatomic,strong) NSMutableArray *colorArray2;
@property (nonatomic,strong) PieChartView *pieChartView;
@property (nonatomic,strong) UIView *pieContainer;
@property (nonatomic)BOOL inOut;
@property (nonatomic,strong) UILabel *selLabel;







@end
