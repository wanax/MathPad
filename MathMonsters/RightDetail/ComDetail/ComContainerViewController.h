//
//  ComContainerViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-8.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComContainerViewController : UIViewController{
    BOOL _firstLaunch;
}

@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) UIViewController *detailViewController;

@end
