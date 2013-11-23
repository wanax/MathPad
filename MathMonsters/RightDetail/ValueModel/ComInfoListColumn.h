//
//  ComInfoListColumn.h
//  MathMonsters
//
//  Created by Xcode on 13-11-22.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComIconListViewController;

@interface ComInfoListColumn : UIViewController<UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
    
}

@property (nonatomic,retain) UITableView *comTable;
@property (nonatomic,retain) NSArray *comList;
@property (nonatomic,retain) NSArray *progressArr;
@property (nonatomic,retain) NSArray *yearValueArr;

@property (nonatomic,retain) ComIconListViewController *iconTableVC;

- (id)init;
-(void)produceProgressForTable;

@end
