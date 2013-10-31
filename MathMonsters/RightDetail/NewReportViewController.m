//
//  NewReportViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "NewReportViewController.h"
#import "NewReportIndicator.h"
#import "NewReportCell.h"
#import "NewComCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVPullToRefresh.h"

@interface NewReportViewController ()

@end

@implementation NewReportViewController

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
    [self addComIcon];
}

-(void)initComponents{
    
    UIImageView *backImgView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newReportBackImg"]] autorelease];
    backImgView.frame=CGRectMake(0,0,924,716);
    [self.view addSubview:backImgView];

    NewReportIndicator *indicator=[[[NewReportIndicator alloc] initWithFrame:CGRectMake(0,0, 924, 60)] autorelease];
    [self.view addSubview:indicator];
    
    self.newReportTable=[[UITableView alloc] initWithFrame:CGRectMake(4,60,568,625)];
    self.newReportTable.backgroundColor=[Utiles colorWithHexString:@"#2D180D"];
    self.newReportTable.delegate=self;
    self.newReportTable.dataSource=self;
    self.newReportTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.newReportTable];
    
    self.newComTable=[[UITableView alloc] initWithFrame:CGRectMake(579,60,340,625)];
    self.newComTable.backgroundColor=[Utiles colorWithHexString:@"#2D180D"];
    self.newComTable.delegate=self;
    self.newComTable.dataSource=self;
    self.newComTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.newComTable];
    
    [self addTableAction];
}



#pragma mark -
#pragma mark Net Get JSON Data

-(void)addNewReport{
    [MBProgressHUD showHUDAddedTo:self.newReportTable animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.articleId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"NewesAnalysereportURL" andParams:params besidesBlock:^(id resObj){
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

-(void)addComIcon{
    [MBProgressHUD showHUDAddedTo:self.newComTable animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.articleId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"NewesAnalysereportURL" andParams:params besidesBlock:^(id resObj){
        [MBProgressHUD hideHUDForView:self.newComTable animated:YES];
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id obj in self.iconArr){
            [temp addObject:obj];
        }
        for (id data in [resObj objectForKey:@"data"]) {
            [temp addObject:data];
        }
        self.iconArr=temp;
        [self.newComTable reloadData];
        self.articleId=[[self.iconArr lastObject] objectForKey:@"articleid"];
        [self.comRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.newComTable];
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
    if (tableView==self.newReportTable) {
        return [self.arrList count];
    } else {
        return [self.iconArr count];
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.newReportTable) {
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
            [(UIScrollView *)[[cell.conciseView subviews] objectAtIndex:0] setBounces:NO];
            NSString *webviewText = @"<style>body{margin:0;color:#967c6c;background-color:transparent;font:16px/18px Custom-Font-Name}</style>";
            NSString *temp=[model objectForKey:@"concise"];
            if([temp length]>56){
                temp=[temp substringToIndex:56];
            }
            NSString *htmlString = [webviewText stringByAppendingFormat:@"%@......", temp];
            NSURL *url = [NSURL URLWithString:[htmlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [cell.conciseView loadHTMLString:htmlString baseURL:nil];
        }
        
        return cell;
    } else {
        static NSString *NewComCellIdentifier = @"NewComCellIdentifier";
        NewComCell *cell = (NewComCell*)[tableView dequeueReusableCellWithIdentifier:NewComCellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewComCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        if(self.iconArr){
            id model=[self.iconArr objectAtIndex:indexPath.row];
            
            [cell.comIconImg setImageWithURL:[NSURL URLWithString:[model objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defauleIcon"]];
            [cell.comIconImg2 setImageWithURL:[NSURL URLWithString:[model objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defauleIcon"]];
            [cell.comIconImg3 setImageWithURL:[NSURL URLWithString:[model objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defauleIcon"]];
            [cell.comIconImg4 setImageWithURL:[NSURL URLWithString:[model objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defauleIcon"]];
        }
        return cell;
    }
    
}

-(void)addTableAction{
    [self.newReportTable addInfiniteScrollingWithActionHandler:^{
        [self addNewReport];
    }];
    [self.newComTable addInfiniteScrollingWithActionHandler:^{
        //[self addNewReport];
    }];
    if(self.reportRefreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.newReportTable.bounds.size.height, self.newReportTable.frame.size.width, self.newReportTable.bounds.size.height)];
        view.delegate = self;
        [self.newReportTable addSubview:view];
        self.reportRefreshHeaderView = view;
        [view release];
    }
    [self.reportRefreshHeaderView refreshLastUpdatedDate];

    if(self.comRefreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.newComTable.bounds.size.height, self.newComTable.frame.size.width, self.newComTable.bounds.size.height)];
        view.delegate = self;
        [self.newComTable addSubview:view];
        self.comRefreshHeaderView = view;
        [view release];
    }
    [self.comRefreshHeaderView refreshLastUpdatedDate];
}


#pragma mark -
#pragma Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}




#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingReportTableViewData{
    [self addNewReport];
    _reportReloading = NO;
}
- (void)doneLoadingComTableViewData{
    [self addComIcon];
    _comReloading = NO;
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.reportRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.comRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.reportRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [self.comRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    
    if (view==self.reportRefreshHeaderView) {
        [_activityReportIndicatorView startAnimating];
        [self performSelector:@selector(doneLoadingReportTableViewData) withObject:nil afterDelay:1.0];
    } else {
        [_activityComIndicatorView startAnimating];
        [self performSelector:@selector(doneLoadingComTableViewData) withObject:nil afterDelay:1.0];
    }
    
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
 
    if (view==self.reportRefreshHeaderView) {
        return _reportReloading;
    } else {
        return _comReloading;
    }
    
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    if (view==self.reportRefreshHeaderView) {
        return [NSDate date];
    } else {
        return [NSDate date];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
