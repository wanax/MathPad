//
//  ClientLongViewController.h
//  UIDemo
//
//  Created by Xcode on 13-6-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  Vision History
//  2013-06-07 | Wanax | 客户登录控制器

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class LoginView;
@class UserRegContainer;

@interface ClientLoginViewController : UIViewController<UITextFieldDelegate>{
    BOOL isGoIn;
}

@property BrowseSourceType sourceType;
@property BOOL isLoginView;

@property (nonatomic,retain) IBOutlet UIImageView *titleImg;
@property (nonatomic,retain) IBOutlet UITextField *userNameField;
@property (nonatomic,retain) IBOutlet UITextField *userPwdField;
@property (nonatomic,retain) IBOutlet UIButton *loginBt;
@property (nonatomic,retain) IBOutlet UIButton *cancelBt;
@property (nonatomic,retain) IBOutlet UIButton *regBt;
@property (nonatomic,retain) IBOutlet UIButton *findPwdBt;
@property (nonatomic,retain) IBOutlet UIButton *autoLoginBt;
@property (nonatomic,retain) IBOutlet UIImageView *autoCheckImg;
@property (nonatomic,retain) IBOutlet UISwitch *rememberPwd;

@property (nonatomic,retain) UserRegContainer *regContainer;

-(IBAction)cancelBtClicked:(UIButton *)bt;
-(IBAction)loginBtClicked:(id)sender;
-(IBAction)backGroundIsClicked;
//-(IBAction)autoBtClicked:(id)sender;
-(IBAction)freeRegBtClicked:(id)sender;
//-(IBAction)findPwdBtClicked:(id)sender;
-(IBAction)rememberPwd:(UISwitch *)s;

-(void)userLoginUserName:(NSString *)userName pwd:(NSString *)pwd;











@end
