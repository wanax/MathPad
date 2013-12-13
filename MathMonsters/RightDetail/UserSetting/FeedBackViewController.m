//
//  FeedBackViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-12-10.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

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
	[self initComponents];
}

-(void)initComponents {
    
    self.view.alpha = 0.8;
    self.view.backgroundColor = [Utiles colorWithHexString:@"#EFEBD9"];
    
    [self addButton:@"取消" frame:CGRectMake(20,10,60,30) fun:@selector(viewDisMiss)];
    [self addButton:@"提交" frame:CGRectMake(100,10,60,30) fun:@selector(msgSubmit)];
    
    UITextView *con = [[[UITextView alloc] initWithFrame:CGRectMake(20,50,500,180)] autorelease];
    con.delegate = self;
    con.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    self.contentView = con;
    [self.view addSubview:self.contentView];
    
}

-(void)addButton:(NSString *)name frame:(CGRect)rect fun:(SEL)fun {
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bt setTitle:name forState:UIControlStateNormal];
    [bt setFrame:rect];
    bt.titleLabel.textAlignment = NSTextAlignmentLeft;
    bt.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    [bt addTarget:self action:fun forControlEvents:UIControlEventTouchUpInside];
    bt.backgroundColor = [UIColor carrotColor];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:bt];
}

-(void)viewDisMiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)msgSubmit {
    
    if (![Utiles isBlankString:self.contentView.text]) {
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"iphone:%@",self.contentView.text],@"content",nil];
        [Utiles postNetInfoWithPath:@"FeedBack" andParams:params besidesBlock:^(id obj){
            if([[obj objectForKey:@"status"] isEqualToString:@"1"]){
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [Utiles ToastNotification:@"发布失败" andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    } else {
        [Utiles showToastView:self.view withTitle:nil andContent:@"请填写信息" duration:1.0];
    }
    
}

#pragma mark -
#pragma TextView Delegate






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
