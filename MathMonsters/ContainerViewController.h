//
//  ContainViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-25.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBarViewController.h"

@interface ContainerViewController : UIViewController<UISearchBarDelegate,LeftBarDelegate>

@property BOOL isShowSetting;

@property (nonatomic,retain) LeftBarViewController *leftViewController;
@property (nonatomic,retain) UIViewController *rightViewController;
@property (nonatomic,retain) UISearchBar *searchBar;

-(void)setRightDetail:(UIViewController *)rightViewController;

@end
