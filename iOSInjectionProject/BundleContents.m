/*
    Generated for Injection of class implementations
*/

#define INJECTION_NOIMPL
#define INJECTION_BUNDLE InjectionBundle9

#import "/Applications/Injection Plugin.app/Contents/Resources/BundleInjection.h"

#undef _instatic
#define _instatic extern

#undef _inglobal
#define _inglobal extern

#undef _inval
#define _inval( _val... ) /* = _val */

#import "BundleContents.h"

#import "/Users/xcode/wanax/oc/MathMonsters/MathMonsters/RightDetail/UserSetting/UserRegByEmailVC.m"


@interface InjectionBundle9 : NSObject
@end
@implementation InjectionBundle9

+ (void)load {
    Class bundleInjection = NSClassFromString(@"BundleInjection");
    extern Class OBJC_CLASS_$_UserRegByEmailVC;
	[bundleInjection loadedClass:INJECTION_BRIDGE(Class)(void *)&OBJC_CLASS_$_UserRegByEmailVC notify:4];
    [bundleInjection loadedNotify:4];
}

@end

