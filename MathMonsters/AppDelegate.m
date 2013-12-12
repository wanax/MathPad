//
//  AppDelegate.m
//  MathMonsters
//
//  Created by Xcode on 13-9-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "SettingMenuViewController.h"
#import "SettingNavigationController.h"
#import "Reachability.h"
#import <Crashlytics/Crashlytics.h>
#import "VerticalTabBarViewController.h"
#import "ClientLoginViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //[Crashlytics startWithAPIKey:@"c59317990c405b2f42582cacbe9f4fa9abe1fefb"];
    [self netChecked];
    [self shouldKeepLogin];
    //[self setPonyDebugger];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initComponents];
    
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    
    return YES;
}

-(void)initComponents{
    
    VerticalTabBarViewController *tabBar=[[[VerticalTabBarViewController alloc] init] autorelease];
    self.verTabBar=tabBar;
    
    SettingNavigationController *nav = [[[SettingNavigationController alloc] initWithRootViewController:self.verTabBar] autorelease];
    SettingMenuViewController *menu= [[[SettingMenuViewController alloc] init] autorelease];
    [menu.view setFrame:CGRectMake(0,0,200,768)];
    self.navigationController=nav;
    self.menuController=menu;
    
    REFrostedViewController *re=[[[REFrostedViewController alloc] initWithContentViewController:self.navigationController menuViewController:self.menuController] autorelease];
    self.frostedViewController =re;
    self.frostedViewController.limitMenuViewSize=YES;
    self.frostedViewController.minimumMenuViewSize=CGSizeMake(200,768);
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    self.window.rootViewController = self.frostedViewController;
    [self.window makeKeyAndVisible];
}

#pragma mark -
#pragma mark PonyDebugger

-(void)setPonyDebugger{
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    [debugger enableRemoteLogging];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
}

#pragma mark -
#pragma mark Keep Login

-(void)shouldKeepLogin{
    if([Utiles isLogin]){
        [self handleTimer:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginKeeping" object:nil];
        [self loginKeeping:nil];
    }
}
-(void)addLoginEventListen{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeeping:) name:@"LoginKeeping" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLoginKeeping:) name:@"LogOut" object:nil];
}

-(void)loginKeeping:(NSNotification*)notification{
    self.loginTimer = [NSTimer scheduledTimerWithTimeInterval: 7000 target: self selector: @selector(handleTimer:) userInfo: nil repeats: YES];
}
-(void)cancelLoginKeeping:(NSNotification*)notification{
    [self.loginTimer invalidate];
}

- (void) handleTimer: (NSTimer *) timer{
    
    id userInfo = [GetUserDefaults(@"UserInfo") objectFromJSONString];
    [ComFun userLoginUserName:userInfo[@"userid"] pwd:userInfo[@"password"] callBack:^(id obj) {
        NSLog(@"Login Success");
    }];
}


#pragma mark -
#pragma mark Net Reachable

-(void)netChecked{
    Reachability* reach = [Reachability reachabilityWithHostname:GetConfigure(@"FrameParamConfig", @"NetCheckURL", NO)];
    reach.reachableOnWWAN = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [reach startNotifier];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable]){
        NSLog(@"Reachable");
        self.isReachable=YES;
    }else{
        NSLog(@"NReachable");
        self.isReachable=NO;
    }
}




@end
