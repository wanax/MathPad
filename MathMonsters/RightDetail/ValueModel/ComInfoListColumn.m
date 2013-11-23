//
//  ComInfoListColumn.m
//  MathMonsters
//
//  Created by Xcode on 13-11-22.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ComInfoListColumn.h"
#import "ComIconListViewController.h"
#import "ComContainerViewController.h"
#import "SVPullToRefresh.h"

@interface ComInfoListColumn ()

@end

@implementation ComInfoListColumn

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initOverAllComponents];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)initOverAllComponents{
    
    UITableView *temp=[[UITableView alloc] initWithFrame:CGRectMake(0,60,790,610)];
    temp.showsVerticalScrollIndicator=NO;
    temp.delegate=self;
    temp.dataSource=self;
    temp.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    temp.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.comTable=temp;
    [self.view addSubview:self.comTable];

    [self.comTable addInfiniteScrollingWithActionHandler:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ComListDataAdd" object:self];
    }];
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.comTable.bounds.size.height, self.comTable.frame.size.width, self.comTable.bounds.size.height)];
        
        view.delegate = self;
        [self.comTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    SAFE_RELEASE(temp);
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(comListDataLoaded)
                                                 name: @"ComListDataLoaded"
                                               object: nil];
}

-(void)produceProgressForTable{
    
}

-(void)comListDataLoaded{
    [self produceProgressForTable];
    [self.comTable reloadData];
}

#pragma mark -
#pragma Table Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comList count];
}


#pragma mark -
#pragma Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ComContainerViewController *comContainerVC=[[[ComContainerViewController alloc] init] autorelease];
    UINavigationController *comNav=[[[UINavigationController alloc] initWithRootViewController:comContainerVC] autorelease];
    comContainerVC.comInfo=[self.comList objectAtIndex:indexPath.row][@"info"];
    [self presentViewController:comNav animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - Table Header View Methods


- (void)doneLoadingTableViewData{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComListDataRefresh" object:self];
    _reloading = NO;
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    self.iconTableVC.iconTable.contentOffset=scrollView.contentOffset;
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
}

@end
