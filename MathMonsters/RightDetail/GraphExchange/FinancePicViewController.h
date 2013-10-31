//
//  DemoCollectionViewController.h
//  googuu
//
//  Created by Xcode on 13-10-12.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXPhotoBrowser.h"
#import "GraphExchangeViewController.h"

@interface FinancePicViewController : UICollectionViewController<CXPhotoBrowserDataSource,CXPhotoBrowserDelegate,GraphExchangeDelegate>{
    CXBrowserNavBarView *navBarView;
    NSInteger page;
}

@property (nonatomic, strong) NSArray *images;
@property (nonatomic,retain) UILabel *imageTitleLabel;
@property (nonatomic, strong) CXPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photoDataSource;

@end
