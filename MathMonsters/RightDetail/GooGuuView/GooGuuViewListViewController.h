//
//  GooGuuViewListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooGuuViewListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
    
}

@property (nonatomic,retain) NSArray *viewDataArr;
@property (nonatomic,retain) NSString *articleId;

@property (nonatomic,retain) UITableView *ggViewTable;

@end
