//
//  NewReportRightListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewReportRightListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{

    BOOL _comReloading;
    __strong UIActivityIndicatorView *_activityComIndicatorView;
    
}

@property (nonatomic,retain) EGORefreshTableHeaderView *comRefreshHeaderView;
@property (nonatomic,retain) UITableView *newComTable;

@property (nonatomic,retain) id articleId;
@property (nonatomic,retain) NSArray *iconArr;

@end
