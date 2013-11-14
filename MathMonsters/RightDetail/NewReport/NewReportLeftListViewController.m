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
    
    self.view.backgroundColor=[UIColor blackColor];
    [self initComponents];
    [self addNewReport];
}

-(void)initComponents{
    
    UITableView *tempTab=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,568,665)] autorelease];
    
    tempTab.backgroundColor=[Utiles colorWithHexString:@"#2D180D"];
    tempTab.delegate=self;
    tempTab.dataSource=self;
    tempTab.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tempTab];
    self.newReportTable=tempTab;
    
    [self addTableAction];
}



#pragma mark -
#pragma mark Net Get JSON Data

-(void)addNewReport{
    [MBProgressHUD showHUDAddedTo:self.newReportTable animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.articleId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"NewestAnalyseReportURL" andParams:params besidesBlock:^(id resObj){
        [MBProgressHUD hideHUDForView:self.newReportTable animated:YES];
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in self.arrList){
            [temp addObject:obj];
        }
        for (id data in [resObj objectForKey:@"data"]) {
            [temp addObject:data];
        }
        self.arrList=temp;
        [self.newReportTable reloadData];
        self.articleId=[[self.arrList lastObject] objectForKey:@"articleid"];
        [self.reportRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.newReportTable];
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
    return [self.arrList count];
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
    
    if(self.arrList){
        id model=[self.arrList objectAtIndex:indexPath.row];
        
        [cell.comIconImg setImageWithURL:[NSURL URLWithString:[model objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defauleIcon"]];
        [cell.comTitleLabel setText:[model objectForKey:@"companyname"]];
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

-(void)cellBtClicked:(UIButton *)bt{
    
    int row=bt.tag;
    NewReportArticleViewController *reportArticleVC=[[[NewReportArticleViewController alloc] init] autorelease];
    UINavigationController *reportNav=[[[UINavigationController alloc] initWithRootViewController:reportArticleVC] autorelease];
    reportArticleVC.comInfo=[self.arrList objectAtIndex:row];
    [self presentViewController:reportNav animated:YES completion:nil];
    
}

-(void)addTableAction{
    [self.newReportTable addInfiniteScrollingWithActionHandler:^{
        [self addNewReport];
    }];
    
    if(self.reportRefreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.newReportTable.bounds.size.height, self.newReportTable.frame.size.width, self.newReportTable.bounds.size.height)];
        view.delegate = self;
        [self.newReportTable addSubview:view];
        self.reportRefreshHeaderView = view;
        SAFE_RELEASE(view);
    }
    [self.reportRefreshHeaderView refreshLastUpdatedDate];
}


#pragma mark -
#pragma Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"here");
}




#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingReportTableViewData{
    [self addNewReport];
    _reportReloading = NO;
}

#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.reportRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.reportRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
   
    [_activityReportIndicatorView startAnimating];
    [self performSelector:@selector(doneLoadingReportTableViewData) withObject:nil afterDelay:1.0];
  
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reportReloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
