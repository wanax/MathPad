//
//  DailyStockIndicator.h
//  MathMonsters
//
//  Created by Xcode on 13-10-28.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMProgressView;

@interface DailyStockIndicator : UIView

@property (nonatomic,retain) UIImageView *comIconView;
@property (nonatomic,retain) UILabel *comNameLabel;
@property (nonatomic,retain) UILabel *marketPriLabel;
@property (nonatomic,retain) UILabel *googuuPriLabel;
@property (nonatomic,retain) UILabel *outLookLabel;

@property (nonatomic,retain) AMProgressView *marketProgress;
@property (nonatomic,retain) AMProgressView *googuuProgress;

@end
