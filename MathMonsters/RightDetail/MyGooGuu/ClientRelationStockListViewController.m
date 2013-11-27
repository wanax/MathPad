//
//  ClientRelationStockListViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-11-14.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "ClientRelationStockListViewController.h"
#import "MyGooGuuIndicator.h"
#import "MyGooGuuCell.h"
#import "AMProgressView.h"
#import "ComContainerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVPullToRefresh.h"

@interface ClientRelationStockListViewController ()

@end

@implementation ClientRelationStockListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.comList=nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[Utiles colorWithHexString:@"#25bfda"];
    
    [self initComponents];
    [self getClientRelationComListInfo];
    
}

-(void)initComponents{
    
    MyGooGuuIndicator *indicator=[[[MyGooGuuIndicator alloc] initWithFrame:CGRectMake(0,0, 924, 60)] autorelease];
    [self.view addSubview:indicator];
    
    UITableView *temp=[[UITableView alloc] initWithFrame:CGRectMake(0,60,928,595)];
    temp.showsVerticalScrollIndicator=NO;
    temp.delegate=self;
    temp.dataSource=self;
    temp.backgroundColor=[Utiles colorWithHexString:@"#472A20"];
    temp.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.comListTable=temp;
    [self.view addSubview:self.comListTable];
    [self addTableAction];
    SAFE_RELEASE(temp);
}


-(void)addTableAction{
    
    if(self.comListRefreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.comListTable.bounds.size.height, self.comListTable.frame.size.width, self.comListTable.bounds.size.height)];
        view.delegate = self;
        [self.comListTable addSubview:view];
        self.comListRefreshHeaderView = view;
        SAFE_RELEASE(view);
    }
    [self.comListRefreshHeaderView refreshLastUpdatedDate];
}

#pragma mark -
#pragma mark Net Get JSON Data

-(void)getClientRelationComListInfo{

    [MBProgressHUD showHUDAddedTo:self.comListTable animated:YES];
    if([Utiles isLogin]){
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Utiles getUserToken], @"token",@"googuu",@"from",
                                nil];
        NSString *reqUrl=@"";
        if (self.clientType==ClientConcerned) {
            reqUrl=@"AttentionData";
        } else {
            reqUrl=@"SavedData";
        }
        [Utiles postNetInfoWithPath:reqUrl andParams:params besidesBlock:^(id obj){
            if(![[obj objectForKey:@"status"] isEqualToString:@"0"]){
                
                self.comList=[NSMutableArray arrayWithArray:[obj objectForKey:@"data"]];
                [self.comListTable reloadData];
                
            }else{
                [Utiles ToastNotification:[obj objectForKey:@"msg"] andView:self.view andLoading:NO andIsBottom:NO andIsHide:YES];
                self.comList=nil;
            }
            [MBProgressHUD hideHUDForView:self.comListTable animated:YES];
            [self.comListRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.comListTable];
            [self.comListTable.infiniteScrollingView stopAnimating];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [MBProgressHUD hideHUDForView:self.comListTable animated:YES];
            [Utiles showToastView:self.view withTitle:nil andContent:@"网络异常" duration:1.5];
        }];
    }else{
        self.comList=nil;
        [Utiles showToastView:self.view withTitle:nil andContent:@"请先登录" duration:1.5];
    }
    
}

#pragma mark -
#pragma Table DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.comList count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath{
    MyGooGuuCell *c=(MyGooGuuCell *)cell;
    if (indexPath.row%2==0) {
        [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack"]];
    } else {
        [c.backImg setImage:[UIImage imageNamed:@"valueModelCellBack3"]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MyGooGuuCellIdentifier = @"MyGooGuuCellIdentifier";
    MyGooGuuCell *cell = (MyGooGuuCell*)[tableView dequeueReusableCellWithIdentifier:MyGooGuuCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyGooGuuCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    if(self.comList){
        id comInfo=[self.comList objectAtIndex:indexPath.row];
        cell.comTitleLabel.text=[comInfo objectForKey:@"companyname"]==nil?@"":[NSString stringWithFormat:@"%@\n(%@%@)",[comInfo objectForKey:@"companyname"],[comInfo objectForKey:@"stockcode"],[comInfo objectForKey:@"market"]];
        if(![Utiles isBlankString:[comInfo objectForKey:@"comanylogourl"]]){
           [cell.comIconImg setImageWithURL:[NSURL URLWithString:[comInfo objectForKey:@"comanylogourl"]] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
        }
        [cell.saveImg setImage:[UIImage imageNamed:@"unsavemodel"]];
        [cell.concernImg setImage:[UIImage imageNamed:@"unconcernmodel"]];
        
        NSNumber *gPriceStr=[comInfo objectForKey:@"googuuprice"];
        float g=[gPriceStr floatValue];
        NSNumber *priceStr=[comInfo objectForKey:@"marketprice"];
        float p = [priceStr floatValue];
        float outLook=(g-p)/p;
        cell.outLookLabel.text=[NSString stringWithFormat:@"%.2f%%",outLook*100];
        if (outLook>=0) {
            [cell.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#BA0020"]];
            [cell.outLookImg setImage:[UIImage imageNamed:@"riseup"]];
        } else {
            [cell.outLookLabel setBackgroundColor:[Utiles colorWithHexString:@"#36871A"]];
            [cell.outLookImg setImage:[UIImage imageNamed:@"down"]];
        }
        
        AMProgressView *am=[[[AMProgressView alloc] initWithFrame:CGRectMake(517, 8, 180, 18)
                                                andGradientColors:[NSArray arrayWithObjects:[UIColor orangeColor], nil]
                                                 andOutsideBorder:NO
                                                      andVertical:NO] autorelease];
        AMProgressView *am2=[[[AMProgressView alloc] initWithFrame:CGRectMake(517, 34, 180, 18)
                                                 andGradientColors:[NSArray arrayWithObjects:[UIColor purpleColor], nil]
                                                  andOutsideBorder:NO
                                                       andVertical:NO] autorelease];
        [cell.contentView addSubview:am];
        [cell.contentView addSubview:am2];
        
        am.emptyPartAlpha = 1.0f;
        am.minimumValue=0;
        am.maximumValue=g+p;
        am.progress=p;
        cell.markPriLabel.text=[NSString stringWithFormat:@"%.2f",p];
        
        am2.emptyPartAlpha = 1.0f;
        am2.minimumValue=0;
        am2.maximumValue=g+p;
        am2.progress=g;
        cell.googuuPriLabel.text=[NSString stringWithFormat:@"%.2f",g];
        
    }
    
    return cell;
}


#pragma mark -
#pragma Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ComContainerViewController *comContainerVC=[[[ComContainerViewController alloc] init] autorelease];
    UINavigationController *comNav=[[[UINavigationController alloc] initWithRootViewController:comContainerVC] autorelease];
    comContainerVC.comInfo=[self.comList objectAtIndex:indexPath.row];
    [self presentViewController:comNav animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -
#pragma mark - Table Header View Methods

- (void)doneLoadingComListTableViewData{
    [self getClientRelationComListInfo];
    _comListReloading = NO;
}

#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.comListRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.comListRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [_activityComListIndicatorView startAnimating];
    [self performSelector:@selector(doneLoadingComListTableViewData) withObject:nil afterDelay:1.0];
    
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _comListReloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date];
}










@end
