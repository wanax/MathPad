//
//  ClientLongViewController.m
//  UIDemo
//
//  Created by Xcode on 13-6-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//
//  客户登录控制器


#import "ClientLoginViewController.h"


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



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor peterRiverColor];
    isGoIn=NO;
    self.userNameField.delegate=self;
    self.userPwdField.delegate=self;
    
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userNameImg"]];
    image.frame=CGRectMake(0,0,20,20);
    self.userNameField.leftView=image;
    self.userNameField.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    UIImageView *image2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwdImg"]];
    image2.frame=CGRectMake(0,0,20,20);
    self.userPwdField.leftView=image2;
    self.userPwdField.leftViewMode = UITextFieldViewModeUnlessEditing;

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
    //[self viewDisMiss];
}



-(void)userLoginUserName:(NSString *)userName pwd:(NSString *)pwd{
    if ([Utiles isNetConnected]) {
        
        [MBProgressHUD showHUDAddedTo:self.view withTitle:@"正在登录" animated:YES];
       
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[userName lowercaseString],@"username",[Utiles md5:pwd],@"password",@"googuu",@"from", nil];
        
        [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id info){

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if([[info objectForKey:@"status"] isEqualToString:@"1"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:[info objectForKey:@"token"] forKey:@"UserToken"];
                
                NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:userName,@"username",pwd,@"password", nil];
                [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"UserInfo"];
                
                NSLog(@"%@",[info objectForKey:@"token"]);
                isGoIn=YES;

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
    NSLog(@"warning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
