//
//  CommonlyMacros.h
//  估股
//
//  Created by Xcode on 13-8-5.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NavigationBar_HEIGHT 44

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define RGB(A, B, C)        [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define V1Log(...) if(verbose>=1) NSLog(@"%s_%d: %@", __func__, __LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define V2Log(...) if(verbose>=2) NSLog(@"%s_%d: %@", __func__, __LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define V3Log(...) if(verbose>=3) NSLog(@"%s_%d: %@", __func__, __LINE__,[NSString stringWithFormat:__VA_ARGS__])

#define SharedAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SAFE_RELEASE(x) [x release];x=nil

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]


#define GetConfigure(A,B,C) [Utiles getConfigureInfoFrom:A andKey:B inUserDomain:C]
#define SetConfigure(A,B,C) [Utiles setConfigureInfoTo:A forKey:B andContent:C]

#define SetUserDefaults(A,B) [[NSUserDefaults standardUserDefaults] setObject:A forKey:B];
#define GetUserDefaults(A) [[NSUserDefaults standardUserDefaults] objectForKey:A]

#define UserDefaults [NSUserDefaults standardUserDefaults]
#define Application [UIApplication sharedApplication]




//use dlog to print while in debug model

#ifdef DEBUG

#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

#   define DLog(...)

#endif





#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)





#if TARGET_OS_IPHONE

//iPhone Device

#endif



#if TARGET_IPHONE_SIMULATOR

//iPhone Simulator

#endif





//ARC

#if __has_feature(objc_arc)

//compiling with ARC

#else

// compiling without ARC

#endif





//G－C－D

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)





#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define ImageNamed(imgName) [UIImage imageNamed:imgName]







#pragma mark - common functions

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }





#pragma mark - degrees/radian functions

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define radianToDegrees(radian) (radian*180.0)/(M_PI)



#pragma mark - color functions

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]



@interface CommonlyMacros : NSObject

@end
