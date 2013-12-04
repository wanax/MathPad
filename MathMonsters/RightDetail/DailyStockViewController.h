//
//  DailyStockViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyStockIndicator;

@interface DailyStockViewController : UIViewController

@property BOOL firstLaunch;

@property (nonatomic,retain) NSString *imageUrl;
@property (nonatomic,retain) id companyInfo;
@property (nonatomic,retain) id driverData;
@property (nonatomic,retain) id jsonData;

@property (nonatomic,retain) DailyStockIndicator *indicator;
@property (nonatomic,retain) NSMutableArray *controllers;

@end
