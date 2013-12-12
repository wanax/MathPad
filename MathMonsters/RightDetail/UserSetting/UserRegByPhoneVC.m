//
//  UserRegByPhoneVC.m
//  MathMonsters
//
//  Created by Xcode on 13-12-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "UserRegByPhoneVC.h"
#import "RegexKitLite.h"
#import "ClientLoginViewController.h"

@interface UserRegByPhoneVC ()

@end

@implementation UserRegByPhoneVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [Utiles colorWithHexString:@"#351F19"];
    [self initComponents];
}


-(void)initComponents {
    
    UITapGestureRecognizer *backTap = [[[UITapGestureRecognizer alloc] init] autorelease];
    [backTap addTarget:self action:@selector(backTap:)];
    [self.view addGestureRecognizer:backTap];
    
    self.getCheckCodeBt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.getCheckCodeBt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCheckCodeBt setFrame:CGRectMake(145,150,80,40)];
    [self.getCheckCodeBt addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getCheckCodeBt];
    
    self.regBt = [self addButton:@"注册" frame:CGRectMake(40,230,120,40) fun:@selector(regBtClicked:)];
    self.cancelBt = [self addButton:@"取消" frame:CGRectMake(180,230,120,40) fun:@selector(cancelBtClicked:)];
    
    KKProgressTimer *tim = [[[KKProgressTimer alloc] initWithFrame:CGRectMake(240,150,40,40)] autorelease];
    self.timer = tim;
    self.timer.delegate=self;
    self.timer.tag=500;
    [self.view addSubview:self.timer];
    
    self.phoneNumField = [self addTextField:@"输入手机号码" frame:CGRectMake(40,30,260,40) returnType:UIReturnKeyNext tag:1 type:UIKeyboardTypeNumberPad isSecure:NO];
    self.pwdField = [self addTextField:@"密码" frame:CGRectMake(40,90,260,40) returnType:UIReturnKeyNext tag:2 type:UIKeyboardTypeDefault isSecure:YES];
    self.checkCodeField = [self addTextField:@"输入验证码" frame:CGRectMake(40,150,95,40) returnType:UIReturnKeyJoin tag:3 type:UIKeyboardTypeNumberPad isSecure:NO];
    
    UILabel *tip = [[[UILabel alloc] initWithFrame:CGRectMake(20,320,308,90)] autorelease];
    tip.text = @"免责声明:估股网竭力提供准确而可靠的数据,但并不保证数据绝对无误,数据如有错误而令阁下蒙受损失,本公司概不负责.";
    tip.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    tip.textColor = [Utiles colorWithHexString:@"#FFF7E1"];
    tip.numberOfLines = 0;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:tip];
}

#pragma mark -
#pragma Action

-(void)backTap:(UITapGestureRecognizer *)tap {
    
    [self.phoneNumField resignFirstResponder];
    [self.checkCodeField resignFirstResponder];
    
}

-(void)cancelBtClicked:(UIButton *)bt {
    [(ClientLoginViewController *)self.parentViewController.parentViewController.parentViewController cancelBtClicked:nil];
}

-(void)regBtClicked:(UIButton *)bt {
    
    NSString *phoneNum=[self.phoneNumField text];
    NSString *passWord=[self.pwdField text];
    NSString *code=[self.checkCodeField text];
    
    if ([Utiles isBlankString:phoneNum] || [Utiles isBlankString:passWord] || [Utiles isBlankString:code]) {
        [Utiles showToastView:self.view withTitle:nil andContent:@"信息不完整" duration:1.0];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:phoneNum,@"mobile",code,@"code",[Utiles md5:passWord],@"password", nil];
        
        [Utiles postNetInfoWithPath:@"UserRegister" andParams:params besidesBlock:^(id obj) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([[obj objectForKey:@"status"] integerValue]!=1){
                [Utiles showToastView:self.view withTitle:nil andContent:[obj objectForKey:@"msg"] duration:2.0];
            }else{
                [ComFun userLoginUserName:phoneNum pwd:passWord callBack:^(id obj) {
                    ClientLoginViewController *parent = (ClientLoginViewController *)self.parentViewController;
                    if (parent.sourceType == VerticalTabBar) {
                        [parent dismissViewControllerAnimated:YES completion:nil];
                    } else if (parent.sourceType == SettingMenu) {
                        [parent.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络错误" duration:1.0];
        }];
    }
    
}

-(void)getCheckCode:(UIButton *)bt{
    
    NSString *phoneNum=[self.phoneNumField text];
    NSString * regex        = @"^1[3|4|5|8][0-9]\\d{4,8}$";
    BOOL isMatch            = [phoneNum isMatchedByRegex:regex];
    if(isMatch){
        [bt setEnabled:NO];
        __block CGFloat i1 = 0;
        [self.timer startWithBlock:^CGFloat {
            return i1++ / 30;
        }];
        
        [bt setTitle:@"请稍后" forState:UIControlStateDisabled];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:phoneNum,@"mobile", nil];
        [Utiles getNetInfoWithPath:@"UserRegVaildCode" andParams:params besidesBlock:^(id obj) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络错误" duration:1.0];
        }];
    }else{
        [Utiles showToastView:self.view withTitle:nil andContent:@"请填写正确手机号码" duration:1.0];
    }
    
    
}

-(UIButton *)addButton:(NSString *)name frame:(CGRect)rect fun:(SEL)fun{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bt setTitle:name forState:UIControlStateNormal];
    [bt setFrame:rect];
    [bt setTitleColor:[Utiles colorWithHexString:@"#fff7e2"] forState:UIControlStateNormal];
    [bt addTarget:self action:fun forControlEvents:UIControlEventTouchUpInside];
    [bt setBackgroundImage:[UIImage imageNamed:@"loginBtBack"] forState:UIControlStateNormal];
    [self.view addSubview:bt];
    return bt;
}

-(UITextField *)addTextField:(NSString *)title frame:(CGRect)rect returnType:(UIReturnKeyType)returnType tag:(NSInteger)tag type:(UIKeyboardType)type isSecure:(BOOL)isPwd{
    UITextField *textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
    textField.delegate = self;
    textField.placeholder = title;
    [textField setTag:tag];
    textField.borderStyle=UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    [textField setBackground:[UIImage imageNamed:@"inputBack"]];
    textField.clearButtonMode=UITextFieldViewModeUnlessEditing;
    textField.returnKeyType = returnType;
    textField.keyboardType=type;
    textField.secureTextEntry = isPwd;
    [self.view addSubview:textField];
    return textField;
}

#pragma mark -
#pragma UITextField Methods Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField.tag < 3) {
        [(UITextField*)[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    } else {
        [self regBtClicked:self.regBt];
    }
    
    return YES;
}

#pragma mark KKProgressTimerDelegate Method
- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    if (percentage >= 1) {
        [progressTimer stop];
    }
}

- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    [self.getCheckCodeBt setEnabled:YES];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
