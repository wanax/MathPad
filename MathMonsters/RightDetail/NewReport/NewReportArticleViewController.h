//
//  NewReportArticleViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKOMultiPageTextView.h"
#import "PageController.h"
#import "CXPhotoBrowser.h"

@interface NewReportArticleViewController : UIViewController  <AKOMultiColumnTextViewDataSource,UIWebViewDelegate,UIScrollViewDelegate,CXPhotoBrowserDataSource,CXPhotoBrowserDelegate,UIGestureRecognizerDelegate>{
    CXBrowserNavBarView *navBarView;
}

@property (nonatomic,retain) UILabel *imageTitleLabel;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) AKOMultiPageTextView *multiPageView;
@property (nonatomic,retain) UIWebView *articleWeb;
@property (nonatomic, strong) CXPhotoBrowser *browser;

@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id articleContent;
@property (nonatomic,retain) NSArray *imageUrlList;
@property (nonatomic,retain) NSArray *webContainer;
@property (nonatomic,retain) NSDictionary *picIndexDic;
@property (nonatomic, strong) NSMutableArray *photoDataSource;

@end