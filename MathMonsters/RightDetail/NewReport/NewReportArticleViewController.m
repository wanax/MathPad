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
    
    self.view.backgroundColor=[UIColor whiteColor];
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
    //[self.view addSubview:self.multiPageView];
    
}

-(void)getArticleContent{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[self.comInfo objectForKey:@"articleid"],@"articleid", nil];
    [Utiles getNetInfoWithPath:@"ArticleURL" andParams:params besidesBlock:^(id article){
        
        self.articleContent=article;
        self.articleWeb=[[UIWebView alloc] initWithFrame:CGRectMake(0,0,512,768)];
        [self.articleWeb loadHTMLString:[article objectForKey:@"content"] baseURL:nil];
        self.articleWeb.delegate=self;
        //[articleWeb sizeToFit];
        [(UIScrollView *)[[self.articleWeb subviews] objectAtIndex:0] setBounces:NO];
        [(UIScrollView *)[[self.articleWeb subviews] objectAtIndex:0] setScrollEnabled:NO];
        [(UIScrollView *)[[self.articleWeb subviews] objectAtIndex:0] setContentSize:CGSizeMake(200,320)];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view addSubview:self.articleWeb];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
}

-(void)backToRoot:(UIBarButtonItem *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma UIWebView Delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGRect frame = webView.frame;
    float n=ceil(height/frame.size.height);
    
    UIScrollView *pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 1024, 768)];
    pageScroll.contentSize = CGSizeMake(n*512,768);
    pageScroll.pagingEnabled = YES;
    pageScroll.delegate = self;
    [pageScroll setShowsHorizontalScrollIndicator:YES];
    
    for(int i=0;i<n;i++){
        
        UIWebView *aWeb=[[UIWebView alloc] initWithFrame:CGRectMake(i*512,-i*768,512,height)];
        [aWeb loadHTMLString:[self.articleContent objectForKey:@"content"] baseURL:nil];
        [(UIScrollView *)[[aWeb subviews] objectAtIndex:0] setScrollEnabled:NO];
        [pageScroll addSubview:aWeb];
        [aWeb release];
        
    }
    [self.view addSubview:pageScroll];
    [UIView animateWithDuration:0.6f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.articleWeb.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.articleWeb removeFromSuperview];
                     }];
    NSLog(@"%@",NSStringFromCGSize([UIScreen mainScreen].bounds.size));
}

#pragma mark -
#pragma AKOMultiColumnTextView DataSource

- (UIView*)akoMultiColumnTextView:(AKOMultiColumnTextView*)textView viewForColumn:(NSInteger)column onPage:(NSInteger)page
{
    if (page == 1 && column == 2)
    {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0,0, 300, 200)] autorelease];
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
