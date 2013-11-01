/*
    Generated for Injection of class implementations
*/

#define INJECTION_NOIMPL
#define INJECTION_BUNDLE InjectionBundle6

#import "/Applications/Injection Plugin.app/Contents/Resources/BundleInjection.h"

#undef _instatic
#define _instatic extern

#undef _inglobal
#define _inglobal extern

#undef _inval
#define _inval( _val... ) /* = _val */

#import "BundleContents.h"

#import "/Users/xcode/wanax/oc/MathMonsters/MathMonsters/RightDetail/FinanceTool/FInanceDetailViewController.m"


@interface InjectionBundle6 : NSObject
@end
@implementation InjectionBundle6

+ (void)load {
    Class bundleInjection = NSClassFromString(@"BundleInjection");
    extern Class OBJC_CLASS_$_FInanceDetailViewController;
	[bundleInjection loadedClass:INJECTION_BRIDGE(Class)(void *)&OBJC_CLASS_$_FInanceDetailViewController notify:4];
    [bundleInjection loadedNotify:4];
}

@end

