//
//  MyProLossListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-19.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyProLossListDelegate <NSObject>

@optional
-(void)theTableIsScroll:(CGPoint)contentOffset;

@end

@interface MyProLossListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,retain) UITableView *proLossTable;

@property (nonatomic,retain) NSArray *proLossArr;
@property (nonatomic,retain) NSArray *yearArr;
@property (nonatomic,retain) NSDictionary *rangeDic;
@property (nonatomic,retain) NSArray *yearToValueDicArr;
@property (nonatomic,retain) NSArray *labelArr;

@property (nonatomic,assign) id<MyProLossListDelegate> delegate;

- (id)initWithClassArr:(NSArray *)classArr andRangDic:(NSDictionary *)rangDic;

@end
