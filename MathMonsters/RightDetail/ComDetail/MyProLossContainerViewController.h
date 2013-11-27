//
//  MyProLossContainerViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-11-19.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProLossListViewController.h"

@interface MyProLossContainerViewController : UIViewController<UIScrollViewDelegate,MyProLossListDelegate>

@property (nonatomic,retain) id comInfo;
@property (nonatomic,retain) NSArray *proLossLists;

@end
