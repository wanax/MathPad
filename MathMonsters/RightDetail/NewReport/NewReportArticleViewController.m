//
//  NewReportArticleViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "NewReportArticleViewController.h"

@interface NewReportArticleViewController ()

@end


@implementation NewReportArticleViewController


- (void)dealloc
{
    self.label = nil;
    self.multiPageView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
	[self getArticleContent];
}

-(void)initComponents{
    
    self.view.backgroundColor=[UIColor nephritisColor];
    self.title=[self.comInfo objectForKey:@"title"];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot:)];
    self.navigationItem.leftBarButtonItem = anotherButton;
    [anotherButton release];

    
    self.multiPageView=[[AKOMultiPageTextView alloc] initWithFrame:CGRectMake(0,0,1034,770)];
    self.multiPageView.viewBackColor=[UIColor whiteColor];
    self.multiPageView.color=[UIColor blackColor];
    self.multiPageView.dataSource = self;
    self.multiPageView.columnInset = CGPointMake(50, 30);
    self.multiPageView.text = [Utiles stringFromFileNamed:@"lorem_ipsum.txt"];
    self.multiPageView.font = [UIFont fontWithName:@"Georgia" size:24.0];
    self.multiPageView.columnCount = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 2 : 3;
    [self.view addSubview:self.multiPageView];
    
}

-(void)getArticleContent{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[self.comInfo objectForKey:@"articleid"],@"articleid", nil];
    [Utiles getNetInfoWithPath:@"ArticleURL" andParams:params besidesBlock:^(id article){
        
        self.articleContent=article;
        UIWebView *articleWeb=[[UIWebView alloc] initWithFrame:CGRectMake(0,0,2024,768)];
        [articleWeb sizeToFit];
        [articleWeb loadHTMLString:[article objectForKey:@"content"] baseURL:nil];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[self.view addSubview:articleWeb];
        [articleWeb release];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)backToRoot:(UIBarButtonItem *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma AKOMultiColumnTextView DataSource

- (UIView*)akoMultiColumnTextView:(AKOMultiColumnTextView*)textView viewForColumn:(NSInteger)column onPage:(NSInteger)page
{
    if (page == 1 && column == 2)
    {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)] autorelease];
        view.backgroundColor = [UIColor redColor];
        return view;
    }
    
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
