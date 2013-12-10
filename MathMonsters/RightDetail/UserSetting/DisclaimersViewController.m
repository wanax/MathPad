//
//  DisclaimersViewController.m
//  googuu
//
//  Created by Xcode on 13-9-3.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "DisclaimersViewController.h"

@interface DisclaimersViewController ()

@end

@implementation DisclaimersViewController


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
    self.title=@"免责声明";
    self.view.backgroundColor = [Utiles colorWithHexString:@"#EFEBD9"];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bt setTitle:@"确定" forState:UIControlStateNormal];
    [bt setFrame:CGRectMake(460,10,60,30)];
    bt.titleLabel.textAlignment = NSTextAlignmentLeft;
    bt.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    [bt addTarget:self action:@selector(viewDisMiss) forControlEvents:UIControlEventTouchUpInside];
    bt.backgroundColor = [UIColor carrotColor];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:bt];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"announce" ofType:@"txt"];
    NSString *textFile = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    UITextView *con = [[[UITextView alloc] initWithFrame:CGRectMake(20,40,500,580)] autorelease];
    con.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    con.text = textFile;
    con.backgroundColor = [Utiles colorWithHexString:@"#EFEBD9"];
    con.showsVerticalScrollIndicator = NO;
    con.delegate = self;
    [self.view addSubview:con];

}

-(void)viewDisMiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
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
