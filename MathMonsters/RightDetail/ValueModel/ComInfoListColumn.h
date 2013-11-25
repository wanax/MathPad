//
//  ComInfoListColumn.h
//  MathMonsters
//
//  Created by Xcode on 13-11-22.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComIconListViewController;
@class ComListController;
@class AMProgressView;

@interface ComInfoListColumn : UIViewController<UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
    
}

@property CGPoint contentOffset;

@property (nonatomic,retain) UITableView *comTable;
@property (nonatomic,retain) NSArray *comList;
@property (nonatomic,retain) NSArray *progressArr;
@property (nonatomic,retain) NSArray *yearValueArr;

@property (nonatomic,retain) ComIconListViewController *iconTableVC;
@property (nonatomic,retain) ComListController *listController;

- (id)init;
-(void)produceProgressForTable;
-(void)produceProgressForClass:(id)data className:(NSString *)className tempGrade2:(NSMutableArray *)tempArr cellValueDic:(NSMutableDictionary *)cellValueDic color:(NSArray *)colorArr x:(int)x;
-(AMProgressView *)makeAProgress:(float)current max:(float)max frame:(CGRect)rect color:(UIColor *)color;

@end
