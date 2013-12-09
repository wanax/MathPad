//
//  UserRegContainer.h
//  MathMonsters
//
//  Created by Xcode on 13-12-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTabBarController;
@class UserRegByEmailVC;
@class UserRegByPhoneVC;

@interface UserRegContainer : UIViewController

@property (nonatomic,retain) MHTabBarController *mhTab;
@property (nonatomic,retain) UserRegByEmailVC *urEmailVC;
@property (nonatomic,retain) UserRegByPhoneVC *urPhoneVC;

@end
