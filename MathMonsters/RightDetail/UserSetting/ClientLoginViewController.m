//
//  ClientLongViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  客户登录控制器


#import "ClientLoginViewController.h"
#import "UserRegisterViewController.h"


@interface ClientLoginViewController ()

@end

@implementation ClientLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if([Utiles isLogin]){
        //[self.navigationController popViewControllerAnimated:YES];
    }

    if([[Utiles getConfigureInfoFrom:@"userconfigure" andKey:@"rememberPwd" inUserDomain:YES] isEqual:@"1"]){
        id userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
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
        
        [self userLoginUserName:name pwd:pwd];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark -
#pragma mark Button Methods


-(IBAction)loginBtClicked:(id)sender{
    [self userLoginUserName:self.userNameField.text pwd:self.userPwdField.text];
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
    UserRegisterViewController *regVC=[[[UserRegisterViewController alloc] init] autorelease];
    regVC.actionType=UserRegister;
    [self presentViewController:regVC animated:YES completion:nil];
}

-(IBAction)backGroundIsClicked{
    [self.userNameField resignFirstResponder];
    [self.userPwdField resignFirstResponder];
}

-(void)userLoginUserName:(NSString *)userName pwd:(NSString *)pwd{
    if ([Utiles isNetConnected]) {
        
        [MBProgressHUD showHUDAddedTo:self.view withTitle:@"正在登录" animated:YES];
       
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[userName lowercaseString],@"username",[Utiles md5:pwd],@"password",@"googuu",@"from", nil];
        
        [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id info){

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if([[info objectForKey:@"status"] isEqualToString:@"1"]){
                [Utiles showToastView:self.view withTitle:nil andContent:@"登录成功" duration:2.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"token"] forKey:@"UserToken"];
                
                NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:userName,@"username",pwd,@"password", nil];
                [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"UserInfo"];
                
                NSLog(@"%@",[info objectForKey:@"token"]);
                isGoIn=YES;
                sleep(1);
                if (self.sourceType == VerticalTabBar) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else if (self.sourceType == SettingMenu) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else {
                NSString *msg=@"";
                if ([info[@"status"] isEqual:@"0"]) {
                    msg=@"用户不存在";
                } else if ([info[@"status"] isEqual:@"2"]){
                    msg=@"邮箱未激活";
                } else if ([info[@"status"] isEqual:@"3"]){
                    msg=@"密码错误";
                }
                [Utiles ToastNotification:msg andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }
    
  
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
