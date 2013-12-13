//
//  GooGuuViewListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "GooGuuViewListViewController.h"
#import "SVPullToRefresh.h"
#import "GooGuuViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewReportArticleViewController.h"

@interface GooGuuViewListViewController ()

@end

@implementation GooGuuViewListViewController

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
    [self getValueViewData:@"" code:@""];
}


-(void)initComponents{
    
    UITableView *t=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,924,800)] autorelease];
    t.dataSource=self;
    t.delegate=self;
    t.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.ggViewTable=t;
    [self.view addSubview:self.ggViewTable];
    
    [self.ggViewTable addInfiniteScrollingWithActionHandler:^{
        [self getValueViewData:self.articleId code:@""];
    }];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.ggViewTable.bounds.size.height, self.ggViewTable.frame.size.width, self.ggViewTable.bounds.size.height)];
        
        view.delegate = self;
        [self.ggViewTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

-(void)getValueViewData:(NSString *)articleID code:(NSString *)stockCode{
    
    [MBProgressHUD showHUDAddedTo:self.ggViewTable animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:articleID,@"articleid",stockCode,@"stockcode", nil];
    [Utiles getNetInfoWithPath:@"GooGuuView" andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in self.viewDataArr){
            [temp addObject:obj];
        }
        for (id data in obj) {
            [temp addObject:data];
        }
        self.viewDataArr=temp;
        self.articleId=[[temp lastObject] objectForKey:@"articleid"];
        [self.ggViewTable reloadData];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.ggViewTable];
        [self.ggViewTable.infiniteScrollingView stopAnimating];
        [MBProgressHUD hideHUDForView:self.ggViewTable animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark Table Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewDataArr count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GooGuuViewCellIdentifier = @"GooGuuViewCellIdentifier";
    GooGuuViewCell *cell = (GooGuuViewCell*)[tableView dequeueReusableCellWithIdentifier:GooGuuViewCellIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GooGuuViewCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
    }
    
    id model=[self.viewDataArr objectAtIndex:indexPath.row];
    
    if([model objectForKey:@"titleimgurl"]){
        [cell.titleImgView setImageWithURL:[NSURL URLWithString:[[model objectForKey:@"titleimgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
    }
    
    [cell.titleLabel setText:[model objectForKey:@"title"]];
    cell.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.titleLabel.numberOfLines=0;
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:19];
 
    cell.conciseWebView.backgroundColor = [UIColor clearColor];
    cell.conciseWebView.opaque = NO;
    cell.conciseWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [(UIScrollView *)[[cell.conciseWebView subviews] objectAtIndex:0] setBounces:NO];
    
    NSString *webviewText = @"<style>body{margin:0px;background-color:transparent;font:16px/22px Custom-Font-Name}</style>";
    
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", [model objectForKey:@"concise"]];
    
    [cell.conciseWebView loadHTMLString:htmlString baseURL:nil];

    [cell.updateTimeLabel setText:[model objectForKey:@"updatetime"]];
    [cell.backLabel setBackgroundColor:[UIColor whiteColor]];
    cell.backLabel.layer.cornerRadius = 5;
    cell.backLabel.layer.borderColor = [UIColor grayColor].CGColor;
    cell.backLabel.layer.borderWidth = 0;
    
    [cell.contentView setBackgroundColor:[UIColor silverColor]];

    UIButton *cellBt=[[[UIButton alloc] initWithFrame:CGRectMake(0,0,924,200)] autorelease];
    cellBt.tag=indexPath.row;
    [cellBt addTarget:self action:@selector(cellBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cellBt];
    
    return cell;
    
}


#pragma mark -
#pragma mark Table Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark General Methods

-(void)cellBtClicked:(UIButton *)bt{
    
    int row=bt.tag;
    NewReportArticleViewController *reportArticleVC=[[[NewReportArticleViewController alloc] init] autorelease];
    UINavigationController *reportNav=[[[UINavigationController alloc] initWithRootViewController:reportArticleVC] autorelease];
    reportArticleVC.comInfo=[self.viewDataArr objectAtIndex:row];
    [self presentViewController:reportNav animated:YES completion:nil];
    
}


#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [self getValueViewData:@"" code:@""];
    _reloading = NO;
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [_activityIndicatorView startAnimating];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    
    return _reloading; // should return if data source model is reloading
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

- (BOOL)shouldAutorotate{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
