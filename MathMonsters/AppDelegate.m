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
#import "ViewController.h"

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

    [self setPonyDebugger];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.right=[[RightViewController alloc] init];
    self.left=[[FontListViewController alloc] init];

    self.left.delegate=self.right;
    
    IIViewDeckController* deckController = [self generateControllerStack];
    [self generateSplitVC];

    self.window.rootViewController = self.splitViewController;
    //[deckController shouldAutorotate];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString *t=[[NSString alloc] init];
    [t toLowerCase];
    
    return YES;
}

-(void)generateSplitVC{
    
    self.splitViewController=[[UISplitViewController alloc] init];
    self.splitViewController.delegate=self.right;
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.left,[[ViewController alloc] init], nil];
    self.splitViewController.viewControllers = viewControllers;
    
}

- (IIViewDeckController *)generateControllerStack {

    PopListViewController *center=[[PopListViewController alloc] init];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:center
                                                                                    leftViewController:self.left];
    deckController.centerController.view.frame=CGRectMake(200,0,2048,748);

    deckController.leftSize = 800;
    
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
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
