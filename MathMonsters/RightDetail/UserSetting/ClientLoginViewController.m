//
//  ClientLongViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  客户登录控制器


#import "ClientLoginViewController.h"
#import "UserRegContainer.h"


@interface ClientLoginViewController ()

@end

@implementation ClientLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isLoginView = YES;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if([Utiles isLogin]){
        //[self.navigationController popViewControllerAnimated:YES];
    }

    if([[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"rememberPwd" inUserDomain:YES] isEqual:@"1"]){
        id userInfo=[GetUserDefaults(@"UserInfo") objectFromJSONString];
        if (userInfo) {
            [self.userNameField setText:userInfo[@"username"]];
            [self.userPwdField setText:userInfo[@"password"]];
        }
        [self.rememberPwd setOn:YES];
    }else{
        [self.rememberPwd setOn:NO];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
}

-(void)initComponents{
    
    isGoIn=NO;
    self.userNameField.delegate=self;
    self.userPwdField.delegate=self;
    UIImageView *image=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userNameFieldIcon"]] autorelease];
    image.frame=CGRectMake(15,0,24,24);
    self.userNameField.leftView=image;
    
    UIImageView *image2=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwdFieldIcon"]] autorelease];
    image2.frame=CGRectMake(15,0,24,24);
    self.userPwdField.leftView=image2;
    
    UserRegContainer *regcontainer = [[[UserRegContainer alloc] init] autorelease];
    self.regContainer = regcontainer;
    self.regContainer.view.frame = CGRectMake(618, 138, 337, 522);
    [self addChildViewController:self.regContainer];
}


#pragma mark -
#pragma mark TextField Method Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.tag==100){
        [self.userNameField resignFirstResponder];
        [self.userPwdField becomeFirstResponder];
    }else if(textField.tag==200){
 
        NSString *name=[self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *pwd=[self.userPwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        [ComFun userLoginUserName:name pwd:pwd callBack:^(id obj) {
            if (self.sourceType == VerticalTabBar) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if (self.sourceType == SettingMenu) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark -
#pragma mark Button Methods


-(IBAction)loginBtClicked:(id)sender{
    [ComFun userLoginUserName:self.userNameField.text pwd:self.userPwdField.text callBack:^(id obj) {
        if (self.sourceType == VerticalTabBar) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (self.sourceType == SettingMenu) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(IBAction)cancelBtClicked:(UIButton *)bt{
    if (self.sourceType == VerticalTabBar) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.sourceType == SettingMenu) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)rememberPwd:(UISwitch *)s{
    if (s.on) {
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"rememberPwd" andContent:@"1"];
    } else {
        [Utiles setConfigureInfoTo:@"userconfigure" forKey:@"rememberPwd" andContent:@"0"];

    }
}

-(IBAction)freeRegBtClicked:(id)sender{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.googuu.net/pages/user/newRegister.htm"]];
    /*UserRegisterViewController *regVC=[[[UserRegisterViewController alloc] init] autorelease];
    regVC.actionType=UserRegister;
    [self presentViewController:regVC animated:YES completion:nil];*/
    
    if (self.isLoginView) {
        [self.view addSubview:self.regContainer.view];
        [self.titleImg setImage:[UIImage imageNamed:@"userRegTextImg"]];
        [self.regBt setTitle:@"登录" forState:UIControlStateNormal];
        self.isLoginView = NO;
    } else {
        [self.regContainer.view removeFromSuperview];
        [self.titleImg setImage:[UIImage imageNamed:@"loginGGTextImg"]];
        [self.regBt setTitle:@"注册" forState:UIControlStateNormal];
        self.isLoginView = YES;
    }
    
    
}

-(IBAction)backGroundIsClicked{
    [self.userNameField resignFirstResponder];
    [self.userPwdField resignFirstResponder];
}



-(void)getUserInfo:(NSString *)token {
    
    NSDictionary *params = @{@"token":token};
    [Utiles getNetInfoWithPath:@"UserInfo" andParams:params besidesBlock:^(id obj) {
        SetUserDefaults(obj,@"UserInfo");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
    NSLog(@"finished");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
