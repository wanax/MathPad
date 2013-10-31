//
//  ValueModelCell.h
//  MathMonsters
//
//  Created by Xcode on 13-10-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValueModelCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *backImg;
@property (nonatomic,retain) IBOutlet UIImageView *comIconImg;
@property (nonatomic,retain) IBOutlet UIImageView *concernImg;
@property (nonatomic,retain) IBOutlet UIImageView *saveImg;
@property (nonatomic,retain) IBOutlet UILabel *comTitleLabel;
@property (nonatomic,retain) IBOutlet UILabel *outLookLabel;
@property (nonatomic,retain) IBOutlet UIImageView *outLookImg;
@property (nonatomic,retain) IBOutlet UILabel *markPriLabel;
@property (nonatomic,retain) IBOutlet UILabel *googuuPriLabel;

@end
