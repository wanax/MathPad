//
//  PageController.m
//  CoreTextWrapper
//
//  Created by Adrian on 7/8/10.
//  Copyright 2010 akosma software. All rights reserved.
//

#import "PageController.h"
#import "AKOMultiPageTextView.h"

@interface PageController ()

@property (nonatomic) CGFloat previousScale;
@property (nonatomic) CGFloat fontSize;

@end


@implementation PageController

@synthesize multiPageView = _multiPageView;
@synthesize label = _label;
@synthesize previousScale = _previousScale;
@synthesize fontSize = _fontSize;

- (void)dealloc 
{
    self.label = nil;
    self.multiPageView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.label.text = @"News of the Day";
    self.label.font = [UIFont fontWithName:@"Polsku" size:34.0];
    self.label.shadowColor = [UIColor lightGrayColor];
    self.label.shadowOffset = CGSizeMake(2, 2);
    

    self.fontSize = 24.0;
    
    self.multiPageView.dataSource = self;
    self.multiPageView.columnInset = CGPointMake(50, 30);
    self.multiPageView.text = [Utiles stringFromFileNamed:@"lorem_ipsum.txt"];
    self.multiPageView.font = [UIFont fontWithName:@"Georgia" size:self.fontSize];
    self.multiPageView.columnCount = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 2 : 3;
}

- (UIView*)akoMultiColumnTextView:(AKOMultiColumnTextView*)textView viewForColumn:(NSInteger)column onPage:(NSInteger)page
{
    if (page == 1 && column == 2)
    {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)] autorelease];
        view.backgroundColor = [UIColor redColor];
        return view;
    }
        
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}


@end

