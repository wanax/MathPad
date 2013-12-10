//
//  FeedBackViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-12-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController<UITextViewDelegate>

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UITextView *contentView;

@end
