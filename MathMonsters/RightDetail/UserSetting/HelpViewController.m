//
//  HelpViewController.m
//  googuu
//
//  Created by Xcode on 13-9-3.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    self.title=@"帮助文档";
    [self.view setBackgroundColor:[UIColor clearColor]];
    if (self.type==UserHelp) {
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(110,0,320,1900)];
        [self.imageView setImage:[UIImage imageNamed:@"help"]];
    } else {
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(110,0,320,1264)];
        [self.imageView setImage:[UIImage imageNamed:@"excelShortcuts"]];
        
        UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
        [back setFrame:CGRectMake(450,0,60,40)];
        [back setTitle:@"返回" forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
    }
    [self.view addSubview:self.imageView];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:pan];
    SAFE_RELEASE(pan);
}

-(void)backBtClicked:(UIButton *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)panAction:(UIPanGestureRecognizer *)pan{
    
    CGPoint change=[pan translationInView:self.view];
    
    if(pan.state==UIGestureRecognizerStateChanged){
        
        if (self.type==UserHelp) {
            self.imageView.frame=CGRectMake(110,MAX(MIN(standard.y+change.y,20),-1520),320,1900);
        } else {
            self.imageView.frame=CGRectMake(110,MAX(MIN(standard.y+change.y,20),-1520),320,1264);
        }
        
    }else if(pan.state==UIGestureRecognizerStateEnded){
        standard=self.imageView.frame.origin;
    }
    
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end