//
//  AppDelegate.m
//  MathMonsters
//
//  Created by Xcode on 13-9-13.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "AppDelegate.h"
#import "ContainerViewController.h"
#import "REFrostedViewController.h"
#import "SettingMenuViewController.h"
#import "SettingNavigationController.h"
#import "Reachability.h"
#import <Crashlytics/Crashlytics.h>
#import "FSVerticalTabBarExampleController.h"

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
    [self setPonyDebugger];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initComponents];
    
    return YES;
}

-(void)initComponents{
    
    ContainerViewController *content=[[ContainerViewController alloc] init];
    FSVerticalTabBarExampleController *test=[[FSVerticalTabBarExampleController alloc] init];
    
    SettingNavigationController *nav = [[[SettingNavigationController alloc] initWithRootViewController:test] autorelease];
    SettingMenuViewController *menu= [[[SettingMenuViewController alloc] init] autorelease];
    [menu.view setFrame:CGRectMake(0,0,200,768)];
    
    self.navigationController=nav;
    self.menuController=menu;
    
    REFrostedViewController *re=[[REFrostedViewController alloc] initWithContentViewController:self.navigationController menuViewController:self.menuController];
    re.view.frame=CGRectMake(0,55,1024,713);
    self.frostedViewController =[re autorelease];
    self.frostedViewController.limitMenuViewSize=YES;
    self.frostedViewController.minimumMenuViewSize=CGSizeMake(200,768);
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    self.window.rootViewController = self.frostedViewController;
    [self.window makeKeyAndVisible];
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
    
    NSUserDefaults *userDeaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[[[userDeaults objectForKey:@"UserInfo"] objectForKey:@"username"] lowercaseString],@"username",[Utiles md5:[[userDeaults objectForKey:@"UserInfo"] objectForKey:@"password"]],@"password",@"googuu",@"from", nil];
    [Utiles getNetInfoWithPath:@"Login" andParams:params besidesBlock:^(id resObj){
        
        if([[resObj objectForKey:@"status"] isEqualToString:@"1"]){
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"UserToke"];
            [userDefaults setObject:[resObj objectForKey:@"token"] forKey:@"UserToken"];
            
            NSLog(@"%@",[resObj objectForKey:@"token"]);
            
        }else {
            NSLog(@"%@",[resObj objectForKey:@"msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
