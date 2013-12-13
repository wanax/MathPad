//
//  UserRegByEmailVC.m
//  MathMonsters
//
//  Created by Xcode on 13-12-9.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "UserRegByEmailVC.h"

@interface UserRegByEmailVC ()

@end

@implementation UserRegByEmailVC

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
	self.view.backgroundColor = [Utiles colorWithHexString:@"#281810"];
    
    UILabel *tip = [[[UILabel alloc] initWithFrame:CGRectMake(40,80,308,90)] autorelease];
    tip.text = @"暂不支持，请到网站进行邮箱注册";
    tip.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    tip.textColor = [Utiles colorWithHexString:@"#FFF7E1"];
    tip.numberOfLines = 0;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:tip];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
