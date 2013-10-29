//
//  RightViewController.m
//  MathMonsters
//
//  Created by Xcode on 13-9-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "RightViewController.h"
#import "FontListViewController.h"
#import "FontSizeViewController.h"
#import "PopListViewController.h"
#import "KLCircleViewController.h"

#define PIE_HEIGHT 280

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)addToolBar{
    
    UIBarButtonItem *fontListBt = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Font"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(rightBtClicked:)];
    UIBarButtonItem *fontSizeBt = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Size"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(popoverFontSize:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    
    self.toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,0,SCREEN_HEIGHT-320,44)];
    [self.toolBar setItems:[NSArray arrayWithObjects:flexibleSpace,fontSizeBt,fontListBt, nil]];
    [self.view addSubview:self.toolBar];
}

-(void)addChart{
    self.inOut = YES;
    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithInt:2],
                       [NSNumber numberWithInt:3],
                       [NSNumber numberWithInt:2],
                       nil];
    
    
    self.colorArray = [NSMutableArray arrayWithObjects:[Utiles colorWithHexString:@"#25bfda"],[Utiles colorWithHexString:@"#9fe855"],[Utiles colorWithHexString:@"#ff5e4d"],nil];
    
    
    //add shadow img
    CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 50-0, PIE_HEIGHT, PIE_HEIGHT);
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView setAmountText:@"-2456.0"];
    [self.view addSubview:self.pieContainer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor grayColor]];
    self.font=[UIFont fontWithName:@"Heiti SC" size:20.0];
    
    [self addChart];
    
   
}

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    self.selLabel.text = [NSString stringWithFormat:@"%2.2f%@",per*100,@"%"];
}


-(void)fontChanged:(UIFont *)font{
    [self.lable setFont:font];
}

-(void)rightBtClicked:(id)sender{

    PopListViewController *flc=[[[PopListViewController alloc] init] autorelease];
    flc.selectedFontName=self.font.fontName;
    [self setupNewPopoverControllerForViewCotroller:flc];
    flc.container=self.currentPopover;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontListControllerDidSelected:) name:@"FontListControllerDidSelect" object:flc];
    [self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)setupNewPopoverControllerForViewCotroller:(UIViewController *)vc{
    
    if(self.currentPopover){
        [self.currentPopover dismissPopoverAnimated:YES];
        [self handleDismissedPopoverController:self.currentPopover];
    }
    self.currentPopover=[[[UIPopoverController alloc] initWithContentViewController:vc] autorelease];
    self.currentPopover.delegate=self;
    
}
-(void)popoverFontSize:(id)sender{
    FontSizeViewController *fsc=[[[FontSizeViewController alloc] initWithNibName:@"FontSizeView" bundle:nil] autorelease];
    fsc.font=self.font;
    [self setupNewPopoverControllerForViewCotroller:fsc];
    self.currentPopover.popoverContentSize=fsc.view.frame.size;
    [self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)fontListControllerDidSelected:(NSNotification *)notification{
    PopListViewController *flc=[notification object];
    UIPopoverController *popoverController=flc.container;
    [popoverController dismissPopoverAnimated:YES];
    [self handleDismissedPopoverController:popoverController];
    self.currentPopover=nil;
    [self.lable setFont:self.font];
}

#pragma mark -
#pragma mark Pop Methods Delegate

-(void)handleDismissedPopoverController:(UIPopoverController *)popoverController{
    
    if([popoverController.contentViewController isMemberOfClass:[PopListViewController class]]){
        PopListViewController *flc=(PopListViewController *)popoverController.contentViewController;
        self.font=[UIFont fontWithName:flc.selectedFontName size:self.font.pointSize];
    }else if([popoverController.contentViewController isMemberOfClass:[FontSizeViewController class]]){
        FontSizeViewController *fsc=(FontSizeViewController *)popoverController.contentViewController;
        self.font=fsc.font;
        [self.lable setFont:self.font];
    }
    
    self.currentPopover=nil;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [self handleDismissedPopoverController:popoverController];
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    
    NSMutableArray *newItems=[[self.toolBar.items mutableCopy] autorelease];
    [newItems insertObject:barButtonItem atIndex:0];
    UIBarButtonItem *spacer=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    [newItems insertObject:spacer atIndex:1];
    [self.toolBar setItems:newItems animated:YES];
    barButtonItem.title=@"My Dudels";
    
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    NSMutableArray *newItems=[[self.toolBar.items mutableCopy] autorelease];
    if([newItems containsObject:barButtonItem]){
        [newItems removeObject:barButtonItem];
        [newItems removeObjectAtIndex:0];
        [self.toolBar setItems:newItems animated:YES];
    }
}

-(void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController{
    if(self.currentPopover){
        [self.currentPopover dismissPopoverAnimated:YES];
        [self handleDismissedPopoverController:self.currentPopover];
    }
    self.currentPopover=pc;
}





-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        self.view.frame=CGRectMake(0,0,1024,768);
    }
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    self.view.frame=CGRectMake(0,0,1024,768);
    return YES;
}












- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
