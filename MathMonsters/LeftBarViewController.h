//
//  LeftBarViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftBarDelegate <NSObject>
@optional
-(void)barChanged:(NSString *)controllerName;
@end

@interface LeftBarViewController : UIViewController

@property (nonatomic,retain) id<LeftBarDelegate> delegate;

@property (nonatomic,retain) UIButton *dailyStockBt;
@property (nonatomic,retain) UIButton *newReportBt;
@property (nonatomic,retain) UIButton *valuModelBt;
@property (nonatomic,retain) UIButton *myGooguuBt;
@property (nonatomic,retain) UIButton *graphExchangeBt;
@property (nonatomic,retain) UIButton *financeToolBt;
@property (nonatomic,retain) UIButton *settingBt;
@property (nonatomic,retain) NSArray *btArr;


@end
