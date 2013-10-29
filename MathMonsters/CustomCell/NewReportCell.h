//
//  NewReportCell.h
//  MathMonsters
//
//  Created by Xcode on 13-10-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewReportCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *comIconImg;
@property (nonatomic,retain) IBOutlet UILabel *comTitleLabel;
@property (nonatomic,retain) IBOutlet UILabel *updateTimeLabel;
@property (nonatomic,retain) IBOutlet UILabel *contentLabel;
@property (nonatomic,retain) IBOutlet UIWebView *conciseView;

@end
