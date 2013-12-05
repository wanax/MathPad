//
//  FSViewController.h
//  FSVerticalTabBarExample
//
//  Created by Truman, Christopher on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVerticalTabBarController.h"

@class SearchComListViewController;

@interface VerticalTabBarViewController : FSVerticalTabBarController<FSTabBarControllerDelegate,UISearchBarDelegate,UIPopoverControllerDelegate>

@property (nonatomic,retain) SearchComListViewController *searchListVC;

@property (nonatomic,retain) UIPopoverController *popVC;
@property (nonatomic,retain) UISearchBar *searchBar;

@end
