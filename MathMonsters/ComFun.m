//
//  ComFun.m
//  MathMonsters
//
//  Created by Xcode on 13-12-12.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComFun.h"

@implementation ComFun

+ (void)userLoginUserName:(NSString *)userName pwd:(NSString *)pwd callBack:(void (^)(id))block{
    
    if ([Utiles isNetConnected]) {
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[userName lowercaseString],@"username",[Utiles md5:pwd],@"password",@"googuu",@"from", nil];
        
        [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id info){
            
            if([[info objectForKey:@"status"] isEqualToString:@"1"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
                SetUserDefaults(info[@"token"],@"UserToken");

                NSDictionary *params = @{@"token":info[@"token"],
                                         @"from":@"googuu"};
                
                [Utiles getNetInfoWithPath:@"UserInfo" andParams:params besidesBlock:^(id obj) {
                    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] init] autorelease];
                    for (id key in obj[@"data"]) {
                        [temp setObject:obj[@"data"][key] forKey:key];
                    }
                    [temp setObject:obj[@"msg"] forKey:@"msg"];
                    [temp setObject:obj[@"status"] forKey:@"status"];
                    NSDictionary *userInfo = temp;
                    SetUserDefaults([userInfo JSONString],@"UserInfo");
                    block(obj);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                }];
                
                NSLog(@"%@",[info objectForKey:@"token"]);
            }/*else {
                NSString *msg=@"";
                if ([info[@"status"] isEqual:@"0"]) {
                    msg=@"用户不存在";
                } else if ([info[@"status"] isEqual:@"2"]){
                    msg=@"邮箱未激活";
                } else if ([info[@"status"] isEqual:@"3"]){
                    msg=@"密码错误";
                }
            }*/
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"from user login %@",error);
        }];
    } else {
        NSLog(@"net failed from user login");
    }
    
}


@end
