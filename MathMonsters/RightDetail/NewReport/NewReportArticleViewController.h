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

@interface NewReportArticleViewController : UIViewController  <AKOMultiColumnTextViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) AKOMultiPageTextView *multiPageView;
@property (nonatomic,retain) UIWebView *articleWeb;

@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) id articleContent;

@end