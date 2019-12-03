//
//  UIDevice+TTUtil.m
//  TTKit
//
//  TTKit on 2019/6/11.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIDevice+TTUtil.h"

@implementation UIDevice (TTUtil)

+ (NSInteger)tt_navigationBarHeight {
    static NSInteger navigationBarHeight = 0;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        navigationBarHeight = (NSInteger)[[UINavigationBar new] sizeThatFits:CGSizeZero].height;
    });
    return navigationBarHeight;
}

+ (NSInteger)tt_tabBarHeight {
    static NSInteger tabBarHeight = 0;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        tabBarHeight = (NSInteger)[[UITabBar new] sizeThatFits:CGSizeZero].height;
    });
    return tabBarHeight;
}

+ (BOOL)tt_isFullScreen {
    if (@available(iOS 11.0, *)) { \
        return [[UIApplication sharedApplication].delegate window].safeAreaInsets.bottom > 0;
    }
    return NO;
}

@end
