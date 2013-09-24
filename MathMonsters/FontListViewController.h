//
//  FontListViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontListDelegate 

-(void)fontChanged:(UIFont *)font;

@end

@interface FontListViewController : UITableViewController

@property (nonatomic,retain) id<FontListDelegate> delegate;

@property (nonatomic,retain) NSArray *fonts;
@property (copy,nonatomic) NSString *selectedFontName;
@property (nonatomic,assign) UIPopoverController *container;

@end
