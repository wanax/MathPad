//
//  UserRegByPhoneVC.h
//  MathMonsters
//
//  Created by Xcode on 13-12-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKProgressTimer.h"

@interface UserRegByPhoneVC : UIViewController<UITextFieldDelegate,KKProgressTimerDelegate>{
    NSInteger selectedTextFieldTag;
}

@property UserActionType actionType;

@property (nonatomic,retain) UIButton *getCheckCodeBt;
@property (nonatomic,retain) UIButton *regBt;
@property (nonatomic,retain) UIButton *cancelBt;
@property (nonatomic,retain) UITextField *phoneNumField;
@property (nonatomic,retain) UITextField *pwdField;
@property (nonatomic,retain) UITextField *checkCodeField;

@property (nonatomic,retain) KKProgressTimer *timer;


@end
