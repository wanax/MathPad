//
//  FontSizeViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-16.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontSizeViewController : UIViewController

@property (nonatomic,retain) IBOutlet UITextView *textView;
@property (nonatomic,retain) IBOutlet UISlider *slider;
@property (nonatomic,retain) IBOutlet UILabel *label;
@property (nonatomic,retain) UIFont *font;

-(IBAction)takeInValueFrom:(id)sender;

@end
