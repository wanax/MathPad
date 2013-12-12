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
#import "ComContainerViewController.h"
#import "NewReportArticleViewController.h"

@interface NewReportRightListViewController ()

@end

@implementation NewReportRightListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        doubleLoad=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initComponents];
    [MBProgressHUD showHUDAddedTo:self.comIconTable animated:YES];
    [self addComIcon:YES];
}


-(void)initComponents{
    
    UITableView *tView=[[[UITableView alloc] initWithFrame:CGRectMake(0,0,350,655)] autorelease];
    tView.backgroundColor=[Utiles colorWithHexString:@"#2D180D"];
    tView.showsVerticalScrollIndicator=NO;
    tView.delegate=self;
    tView.dataSource=self;
    tView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.comIconTable=tView;
    [self.view addSubview:self.comIconTable];
    
    [self.comIconTable addInfiniteScrollingWithActionHandler:^{
        [self addComIcon:NO];
    }];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.comIconTable.bounds.size.height, self.comIconTable.frame.size.width, self.comIconTable.bounds.size.height)];
        
        view.delegate = self;
        [self.comIconTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

#pragma mark -
#pragma Net Get JSON Data

-(void)addComIcon:(BOOL)isReflash{
    
    if (isReflash) {
        self.articleId = @"";
    }
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.articleId,@"articleid", nil];;
    [Utiles getNetInfoWithPath:@"NewestAnalyseReportURL" andParams:params besidesBlock:^(id resObj){
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        if (!isReflash) {
            for(id obj in self.comIcons){
                [temp addObject:obj];
            }
            self.articleId=[[self.comIcons lastObject] objectForKey:@"articleid"];
        } else {
            doubleLoad = YES;
        }
        for (id data in [resObj objectForKey:@"data"]) {
            [temp addObject:data];
        }
        self.comIcons=temp;
        [self.comIconTable reloadData];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.comIconTable];
        [self.comIconTable.infiniteScrollingView stopAnimating];
        if(doubleLoad){
            self.articleId=[[self.comIcons lastObject] objectForKey:@"articleid"];
            [self addComIcon:NO];
            doubleLoad=NO;
        }
        [MBProgressHUD hideHUDForView:self.comIconTable animated:YES];
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
    return [self.comIcons count]/4;
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
    if(self.comIcons){
        
        id model=[self.comIcons objectAtIndex:(indexPath.row*4)];
        id model2=[self.comIcons objectAtIndex:(indexPath.row*4)+1];
        id model3=[self.comIcons objectAtIndex:(indexPath.row*4)+2];
        id model4=[self.comIcons objectAtIndex:(indexPath.row*4)+3];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [self setBtBackImg:[NSArray arrayWithObjects:cell.comIconBt,cell.comIconBt2,cell.comIconBt3,cell.comIconBt4, nil]
                    models:[NSArray arrayWithObjects:model,model2,model3,model4, nil]
                    index:indexPath.row
                   manager:manager];

    }
    return cell;
    
}

-(void)setBtBackImg:(NSArray *)bts models:(NSArray *)models index:(int)index manager:(SDWebImageManager *)manager{
    for(int i=0;i<[bts count];i++){
        [manager downloadWithURL:[NSURL URLWithString:[models[i] objectForKey:@"comanylogourl"]]
                         options:0
                        progress:^(NSUInteger receivedSize, long long expectedSize){}
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                           if (image){
                               [bts[i] setBackgroundImage:image forState:UIControlStateNormal];
                           }
                       }];
        ((UIButton *)bts[i]).tag=index*4+i;
        [(UIButton *)bts[i] addTarget:self action:@selector(comIconBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)comIconBtClicked:(UIButton *)bt{

    NSDictionary *param=@{@"stockcode":self.comIcons[bt.tag][@"stockcode"]};
    [Utiles getNetInfoWithPath:@"GetCompanyInfo" andParams:param besidesBlock:^(id obj) {
        
        if ([obj[@"hasmodel"] boolValue]) {
            ComContainerViewController *comContainerVC=[[[ComContainerViewController alloc] init] autorelease];
            UINavigationController *comNav=[[[UINavigationController alloc] initWithRootViewController:comContainerVC] autorelease];
            comContainerVC.comInfo=[self.comIcons objectAtIndex:bt.tag];
            [self presentViewController:comNav animated:YES completion:nil];
        } else {
            NewReportArticleViewController *reportArticleVC=[[[NewReportArticleViewController alloc] init] autorelease];
            UINavigationController *reportNav=[[[UINavigationController alloc] initWithRootViewController:reportArticleVC] autorelease];
            reportArticleVC.comInfo=self.comIcons[bt.tag];
            [self presentViewController:reportNav animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark -
#pragma mark Table Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [self addComIcon:YES];
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
