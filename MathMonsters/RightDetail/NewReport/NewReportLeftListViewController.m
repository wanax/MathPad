//
//  NewReportLeftListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "NewReportLeftListViewController.h"
#import "NewReportCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVPullToRefresh.h"
#import "NewReportArticleViewController.h"
#import "PageController.h"
#import "NewComCell.h"

@interface NewReportLeftListViewController ()

@end

@implementation NewReportLeftListViewController

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
    [self addReport:YES];
}


-(void)initComponents{
    
    UITableView *tView=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,568,665)] autorelease];
    tView.backgroundColor=[Utiles colorWithHexString:@"#2D180D"];
    tView.showsVerticalScrollIndicator=NO;
    tView.delegate=self;
    tView.dataSource=self;
    tView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.reportTable=tView;
    [self.view addSubview:self.reportTable];
    
    [self.reportTable addInfiniteScrollingWithActionHandler:^{
        [self addReport:NO];
    }];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.reportTable.bounds.size.height, self.reportTable.frame.size.width, self.reportTable.bounds.size.height)];
        
        view.delegate = self;
        [self.reportTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

#pragma mark -
#pragma Net Get JSON Data

-(void)addReport:(BOOL)isReflash{
    if (isReflash) {
        self.articleId = @"";
    }
    [MBProgressHUD showHUDAddedTo:self.reportTable animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.articleId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"NewestAnalyseReportURL" andParams:params besidesBlock:^(id resObj){
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        
        if (!isReflash) {
            for(id obj in self.reports){
                [temp addObject:obj];
            }
            
        }
        for (id data in [resObj objectForKey:@"data"]) {
            [temp addObject:data];
        }
        self.reports=temp;
        [self.reportTable reloadData];
        self.articleId=[[self.reports lastObject] objectForKey:@"articleid"];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.reportTable];
        [self.reportTable.infiniteScrollingView stopAnimating];
        [MBProgressHUD hideHUDForView: self.reportTable animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
    }];
    
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.reports count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *NewReportCellIdentifier = @"NewReportCellIdentifier";
    NewReportCell *cell = (NewReportCell*)[tableView dequeueReusableCellWithIdentifier:NewReportCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewReportCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    if(self.reports){
        id model=[self.reports objectAtIndex:indexPath.row];
        
        [cell.comIconImg setImageWithURL:[NSURL URLWithString:[model objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defauleIcon"]];
        [cell.comTitleLabel setText:[model objectForKey:@"title"]];
        [cell.updateTimeLabel setText:[model objectForKey:@"updatetime"]];
        cell.conciseView.backgroundColor = [UIColor clearColor];
        cell.conciseView.opaque = NO;
        cell.conciseView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        UIButton *cellBt=[[[UIButton alloc] initWithFrame:CGRectMake(0,0,570,135)] autorelease];
        cellBt.tag=indexPath.row;
        [cellBt addTarget:self action:@selector(cellBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cellBt];
        
        [(UIScrollView *)[[cell.conciseView subviews] objectAtIndex:0] setBounces:NO];
        NSString *webviewText = @"<style>body{margin:0;color:#967c6c;background-color:transparent;font:16px/18px Custom-Font-Name}</style>";
        NSString *temp=[model objectForKey:@"concise"];
        if([temp length]>56){
            temp=[temp substringToIndex:56];
        }
        NSString *htmlString = [webviewText stringByAppendingFormat:@"%@......", temp];
        [cell.conciseView loadHTMLString:htmlString baseURL:nil];
    }
    
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
    reportArticleVC.comInfo=[self.reports objectAtIndex:row];
    [self presentViewController:reportNav animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [self addReport:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
