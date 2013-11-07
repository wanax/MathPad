//
//  NewReportRightListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "NewReportRightListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVPullToRefresh.h"
#import "NewComCell.h"

@interface NewReportRightListViewController ()

@end

@implementation NewReportRightListViewController

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
    [self addComIcon];
}

-(void)initComponents{
 
    self.newComTable=[[UITableView alloc] initWithFrame:CGRectMake(0,0,340,625)];
    self.newComTable.backgroundColor=[Utiles colorWithHexString:@"#2D180D"];
    self.newComTable.delegate=self;
    self.newComTable.dataSource=self;
    self.newComTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.newComTable];
    [self addTableAction];
}



#pragma mark -
#pragma mark Net Get JSON Data


-(void)addComIcon{
    [MBProgressHUD showHUDAddedTo:self.newComTable animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.articleId,@"articleid", nil];
    [Utiles getNetInfoWithPath:@"NewestAnalyseReportURL" andParams:params besidesBlock:^(id resObj){
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
    return [self.iconArr count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

-(void)addTableAction{
    
    [self.newComTable addInfiniteScrollingWithActionHandler:^{
        //[self addNewReport];
    }];
    
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

- (void)doneLoadingComTableViewData{
    [self addComIcon];
    _comReloading = NO;
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.comRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.comRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{

    [_activityComIndicatorView startAnimating];
    [self performSelector:@selector(doneLoadingComTableViewData) withObject:nil afterDelay:1.0];

}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _comReloading;
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
