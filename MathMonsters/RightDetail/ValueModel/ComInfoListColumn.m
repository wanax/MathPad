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
#import "ComListController.h"
#import "SVPullToRefresh.h"
#import "AMProgressView.h"

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
    
    UITableView *temp=[[UITableView alloc] initWithFrame:CGRectMake(0,60,790,600)];
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.comTable];
    [self.comTable.infiniteScrollingView stopAnimating];
}

-(void)produceProgressForClass:(id)data className:(NSString *)className tempGrade2:(NSMutableArray *)tempArr cellValueDic:(NSMutableDictionary *)cellValueDic color:(NSArray *)colorArr x:(int)x{
    
    id classData=data[className];
    if (![classData isKindOfClass:[NSNull class]]) {
        NSMutableArray *hisClassDatas=[[[NSMutableArray alloc] init] autorelease];
        for (id obj in classData[@"array"]){
            if([obj[@"h"] boolValue]){
                [hisClassDatas addObject:obj];
            }
        }
        NSArray *dataArr=nil;
        if ([hisClassDatas count]>4) {
            NSMutableArray *temp=[NSMutableArray arrayWithCapacity:4];
            for(int i=[hisClassDatas count]-1,j=3;j>=0;j--,i--){
                [temp addObject:hisClassDatas[i]];
            }
            dataArr=[[temp reverseObjectEnumerator] allObjects];;
        } else if ([hisClassDatas count]==4) {
            dataArr=hisClassDatas;
        } else if ([hisClassDatas count]<4 && [hisClassDatas count] > 0) {
            int n = [hisClassDatas count];
            NSNumberFormatter *formatter=[[[NSNumberFormatter alloc] init] autorelease];
            [formatter setPositiveFormat:@"00"];
            while (n++ < 4) {

                id obj = hisClassDatas[0];
                NSString *y=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:@([obj[@"y"] integerValue]-1)]];
                NSDictionary *point=@{@"y":y,
                                      @"id":@"",
                                      @"h":@(true),
                                      @"v":@(0)
                                      };
                NSAssert(point, @"nilnil");
                [hisClassDatas insertObject:point atIndex:0];
                dataArr = hisClassDatas;
            }
        }
        
        int n=0;
        NSMutableDictionary *tempGrade2Dic=[[[NSMutableDictionary alloc] init] autorelease];
        for(id obj in dataArr){
            [tempArr addObject:[self makeAProgress:[obj[@"v"] doubleValue] max:1 frame:CGRectMake(x,n*15+2, 165, 10) color:[colorArr objectAtIndex:n]]];
            [tempGrade2Dic setObject:obj[@"v"] forKey:obj[@"y"]];
            n++;
        }
        [cellValueDic setObject:tempGrade2Dic forKey:className];
    }
    
}

-(AMProgressView *)makeAProgress:(float)current max:(float)max frame:(CGRect)rect color:(UIColor *)color{
    
    AMProgressView *am=[[[AMProgressView alloc] initWithFrame:rect
                                            andGradientColors:[NSArray arrayWithObjects:color, nil]
                                             andOutsideBorder:NO
                                                  andVertical:NO] autorelease];
    
    am.emptyPartAlpha = 1.0f;
    am.minimumValue=0;
    am.maximumValue=max;
    am.progress=current;
    return am;
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
    
    self.listController.updateTime=@"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComListDataRefresh" object:self];
    _reloading = NO;
    
}


#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    self.listController.contentOffset=scrollView.contentOffset;
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
