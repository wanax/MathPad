//
//  AppDelegate.m
//  MathMonsters
//
//  Created by Xcode on 13-9-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AppDelegate.h"
#import "RightViewController.h"
#import "FontListViewController.h"
#import "CenterViewController.h"
#import "IIViewDeckController.h"
#import "PopListViewController.h"
#import "PieViewController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "ContainerViewController.h"
#import "REFrostedViewController.h"
#import "DEMOMenuViewController.h"
#import "DEMONavigationController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

-(void)setPonyDebugger{
    PDDebugger *debugger = [PDDebugger defaultInstance];    
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    
    [debugger enableRemoteLogging];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.left=[[FontListViewController alloc] init];
    //[self setPonyDebugger];
    ContainerViewController *content=[[ContainerViewController alloc] init];
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:content];
    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] init];
    [menuController.view setFrame:CGRectMake(0,0,200,768)];
    REFrostedViewController *re=[[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    self.frostedViewController =[re autorelease];
    self.frostedViewController.limitMenuViewSize=YES;
    self.frostedViewController.minimumMenuViewSize=CGSizeMake(200,768);
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    self.window.rootViewController = self.frostedViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)generateMM{
    LeftViewController * leftDrawer = [[LeftViewController alloc] init];
    leftDrawer.view.backgroundColor = [UIColor blackColor];
    ContainerViewController * center = [[ContainerViewController alloc] init];
    center.view.backgroundColor = [UIColor colorWithRed:86/255.0 green:116/255.0 blue:35/255.0 alpha:1.0];
//    FontListViewController *list=[[[FontListViewController alloc] init] autorelease];
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:center
                                             leftDrawerViewController:leftDrawer];
    
    [drawerController setMaximumLeftDrawerWidth:200];
    //[drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window.rootViewController = drawerController;
}

-(void)generateSplitVC2{
    
    self.split2ViewController=[[MGSplitViewController alloc] init];
    self.split2ViewController.delegate=self.right;
    self.right.view.frame=CGRectMake(0,0,824,748);
    self.left.view.frame=CGRectMake(0,0,200,748);
    self.split2ViewController.detailViewController=self.right;
    self.split2ViewController.masterViewController=self.left;
    self.window.rootViewController = self.split2ViewController;
}

-(void)generateSplitVC{
    
    self.splitViewController=[[UISplitViewController alloc] init];
    self.splitViewController.delegate=self.right;
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.left,[[PieViewController alloc] init], nil];
    self.splitViewController.viewControllers = viewControllers;
    self.window.rootViewController = self.splitViewController;
    
}

- (void)generateControllerStack {

    PieViewController *center=[[PieViewController alloc] init];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:center
                                                                                    leftViewController:self.left];

    deckController.leftSize = 800;
    
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    self.window.rootViewController = deckController;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
