//
//  ClientRelationStockListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientRelationStockListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    BOOL _comListReloading;
    __strong UIActivityIndicatorView *_activityComListIndicatorView;
    
}

@property BrowseSourceType clientType;

@property (nonatomic,retain) NSArray *comList;

@property (nonatomic,retain) EGORefreshTableHeaderView *comListRefreshHeaderView;
@property (nonatomic,retain) UITableView *comListTable;

@end
