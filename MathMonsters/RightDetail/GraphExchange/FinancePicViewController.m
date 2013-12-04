//
//  DemoCollectionViewController.m
//  googuu
//
//  Created by Xcode on 13-10-12.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinancePicViewController.h"
#import "FinanPicCollectCell.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface FinancePicViewController ()

@end

static NSString *GraphExcCellIdentifier = @"GraphExcCellIdentifier";

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@implementation FinancePicViewController

@synthesize images = _images;

-(void)loadView
{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
    page=1;
    NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
    self.photoDataSource=temp;
    CXPhotoBrowser *c=[[[CXPhotoBrowser alloc] initWithDataSource:self delegate:self] autorelease];
    self.browser = c;
    //self.browser.wantsFullScreenLayout = NO;
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#22130B"]];
    self.images=[[NSArray alloc] init];
    [self addPics:@"" reset:NO];
}

-(void)initComponents{
    UICollectionViewFlowLayout *flowLayout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    [flowLayout setItemSize:CGSizeMake(163, 309)];
    flowLayout.sectionInset = UIEdgeInsetsMake(10,15,5,15);
    [flowLayout setMinimumLineSpacing:5.0];
    [flowLayout setMinimumInteritemSpacing:5.0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *co=[[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout] autorelease];
    self.collectionView = co;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PicCollectionCell" bundle:nil] forCellWithReuseIdentifier:GraphExcCellIdentifier];
    [self.collectionView setBackgroundColor:[Utiles colorWithHexString:@"#5b4d41"]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [self addPics:@"" reset:NO];
    }];
    
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

-(void)addPics:(NSString *)keyWord reset:(BOOL)reset{
    if([keyWord isEqualToString:@"全部"]){
        keyWord=@"";
    }
    if (reset) {
        page=1;
    }
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:keyWord,@"keyword",[NSString stringWithFormat:@"%d",page],@"offset", nil];
    [Utiles getNetInfoWithPath:@"Fchart" andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        if (reset) {
            for(id t in obj){
                [temp addObject:t];
            }
        } else {
            for(id t in self.images){
                [temp addObject:t];
            }
            for(id t in obj){
                [temp addObject:t];
            }
        }
        [self.photoDataSource removeAllObjects];
        for (id obj in temp) {
            CXPhoto *photo2=[[[CXPhoto alloc] initWithURL:[NSURL URLWithString:[obj objectForKey:@"url"]]] autorelease];
            [self.photoDataSource addObject:photo2];
        }
        self.images=temp;
        [self.collectionView reloadData];
        [self.collectionView.infiniteScrollingView stopAnimating];
        page++;
        [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark GraphExchange Delegate
-(void)keyWordChanged:(NSString *)key{
    [self addPics:key reset:YES];
}

#pragma mark - UICollectionView DataSource & Delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FinanPicCollectCell *cell = (FinanPicCollectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:GraphExcCellIdentifier forIndexPath:indexPath];
    id model=[self.images objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[model objectForKey:@"smallImage"]]
                   placeholderImage:[UIImage imageNamed:@"LOADING.png"]];
    cell.titleLabel.text=[model objectForKey:@"title"];
    cell.titleLabel.alpha=0.6;
    cell.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.titleLabel.numberOfLines=0;
    cell.titleLabel.backgroundColor=[UIColor blackColor];
    cell.sourceLabel.text=[NSString stringWithFormat:@"采集于%@",[model objectForKey:@"source"]];
    cell.layer.cornerRadius=5;
    cell.layer.borderWidth=0;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0;
}

#pragma mark -
#pragma mark CXPhotoBrowserDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.browser setInitialPageIndex:indexPath.row];
    [self presentViewController:self.browser animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index{
    [self.imageTitleLabel setText:[NSString stringWithFormat:@"%d/%d",(index+1),[self.images count]]];
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
        [doneButton setFrame:CGRectMake(size.width - 120, 5, 100, 60)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [doneButton.layer setBorderColor:colorref];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [navBarView addSubview:doneButton];
        
        UILabel *label=[[[UILabel alloc] init] autorelease];
        self.imageTitleLabel = label;
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
