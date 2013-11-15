//
//  NewReportLeftListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewReportLeftListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>{
    
    BOOL _reportReloading;
    __strong UIActivityIndicatorView *_activityReportIndicatorView;
    
}

@property (nonatomic,retain) EGORefreshTableHeaderView *reportRefreshHeaderView;

@property (nonatomic,retain) UITableView *newReportTable;

@property (nonatomic,retain) NSMutableArray *arrList;
@property (nonatomic,retain) NSString *imageUrl;
@property (nonatomic,retain) id companyInfo;
@property (nonatomic,retain) NSString *articleId;

@end
