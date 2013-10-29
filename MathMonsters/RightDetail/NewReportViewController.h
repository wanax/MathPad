//
//  NewReportViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface NewReportViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{

    BOOL _reportReloading;
    BOOL _comReloading;
    
    __strong UIActivityIndicatorView *_activityReportIndicatorView;
    __strong UIActivityIndicatorView *_activityComIndicatorView;
    
}

@property (nonatomic,retain) EGORefreshTableHeaderView *reportRefreshHeaderView;
@property (nonatomic,retain) EGORefreshTableHeaderView *comRefreshHeaderView;

@property (nonatomic,retain) UITableView *newReportTable;
@property (nonatomic,retain) UITableView *newComTable;

@property (nonatomic,retain) NSMutableArray *arrList;
@property (nonatomic,retain) NSString *imageUrl;
@property (nonatomic,retain) id companyInfo;
@property (nonatomic,retain) NSString *articleId;

@property (nonatomic,retain) NSArray *iconArr;

@end
