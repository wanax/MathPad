//
//  NewReportArticleViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-7.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "NewReportArticleViewController.h"

@interface NewReportArticleViewController ()

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@end


@implementation NewReportArticleViewController


- (void)dealloc
{
    self.label = nil;
    self.multiPageView = nil;
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *t=[[[NSMutableArray alloc] init] autorelease];
        self.photoDataSource=t;
    }
    return self;
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
    
    CXPhotoBrowser *c=[[[CXPhotoBrowser alloc] initWithDataSource:self delegate:self] autorelease];
    self.browser = c;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot:)];
    self.navigationItem.leftBarButtonItem = anotherButton;
    [anotherButton release];
    
}

-(void)getArticleContent{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[self.comInfo objectForKey:@"articleid"],@"articleid", nil];
    [Utiles getNetInfoWithPath:@"ArticleURL" andParams:params besidesBlock:^(id article){
        
        self.articleContent=article;
        UIWebView *web=[[[UIWebView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)] autorelease];
        self.articleWeb=web;
        [self.articleWeb loadHTMLString:[article objectForKey:@"content"] baseURL:nil];
        self.articleWeb.delegate=self;
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
#pragma mark UIWebView Data Source

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self getImgUrl];
    int n=0;
    NSMutableDictionary *dic=[[[NSMutableDictionary alloc] init] autorelease];
    [self.photoDataSource removeAllObjects];
    for (id obj in self.imageUrlList) {
        CXPhoto *photo=[[[CXPhoto alloc] initWithURL:[NSURL URLWithString:obj]] autorelease];
        [self.photoDataSource addObject:photo];
        [dic setObject:[NSNumber numberWithInt:(n++)] forKey:obj];
    }
    self.picIndexDic=dic;
    [self addTapOnWebView];

}

-(void)getImgUrl{
    NSString *urlStr=[self.articleWeb stringByEvaluatingJavaScriptFromString:@"var str=\"\";\
                      function imgUrl(){\
                      var temp = document.getElementsByTagName(\"img\");\
                      for (var i = 0; i < temp.length; i ++) {\
                      str+=temp[i].src+\"|\";\
                      }\
                      return str;\
                      }\
                      imgUrl();"];
    NSMutableArray *tempArr=[[[NSMutableArray alloc] initWithArray:[urlStr componentsSeparatedByString:@"|"]] autorelease];
    [tempArr removeLastObject];
    self.imageUrlList=tempArr;
}

#pragma mark -
#pragma mark UIWebView Delegate

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.articleWeb addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.articleWeb];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.articleWeb stringByEvaluatingJavaScriptFromString:imgURL];
    if (urlToSave.length > 0) {
        int index=[[self.picIndexDic objectForKey:urlToSave] intValue];
        [self.browser setInitialPageIndex:index];
        [self presentViewController:self.browser animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark CXPhotoBrowserDelegate

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index{
    [self.imageTitleLabel setText:[NSString stringWithFormat:@"%d/%d",(index+1),[self.photoDataSource count]]];
}

#pragma mark - CXPhotoBrowserDataSource
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return [self.photoDataSource count];
}
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoDataSource.count)
        return [self.photoDataSource objectAtIndex:index];
    return nil;
}

- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    if (!navBarView)
    {
        navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
        
        [navBarView setBackgroundColor:[UIColor clearColor]];
        
        UIView *bkgView = [[[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height)] autorelease];
        [bkgView setBackgroundColor:[UIColor blackColor]];
        bkgView.alpha = 0.2;
        bkgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [navBarView addSubview:bkgView];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [doneButton setTitle:NSLocalizedString(@"返回",@"Dismiss button title") forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(size.width - 120, 5,100, 60)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [doneButton.layer setBorderColor:colorref];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [navBarView addSubview:doneButton];
        
        UILabel *l=[[[UILabel alloc] init] autorelease];
        self.imageTitleLabel = l;
        [self.imageTitleLabel setFrame:CGRectMake((size.width - 60)/2,0, 60, 40)];
        //[self.imageTitleLabel setCenter:navBarView.center];
        [self.imageTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.imageTitleLabel setFont:[UIFont boldSystemFontOfSize:20.]];
        [self.imageTitleLabel setTextColor:[UIColor whiteColor]];
        [self.imageTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.imageTitleLabel setText:@""];
        self.imageTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        [self.imageTitleLabel setTag:BROWSER_TITLE_LBL_TAG];
        [navBarView addSubview:self.imageTitleLabel];
    }
    
    return navBarView;
}

#pragma mark - PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (BOOL)shouldAutorotate{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
