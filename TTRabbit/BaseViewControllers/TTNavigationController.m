//
//  TTNavigationController.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTNavigationController.h"
#import "TTNavigationControllerChildProtocol.h"
#import "TTCategories.h"
#import <objc/runtime.h>

@interface TTNavigationController () <UINavigationControllerDelegate, UINavigationBarDelegate>

@end

@implementation TTNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [self swizzleInstanceMethod:@selector(navigationBar:shouldPopItem:) with:@selector(tt_navigationBar:shouldPopItem:)];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 自定义返回图片(在返回按钮旁边) 这个效果由navigationBar控制
    UIImage *backIndicatorImage = self.backIndicatorImage ?: (TTNavigationController.defaultBackIndicatorImage ?: [UIImage imageNamed:@"icon_nav_back"]);
    backIndicatorImage = [backIndicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationBar setBackIndicatorImage:backIndicatorImage];
    [self.navigationBar setBackIndicatorTransitionMaskImage:backIndicatorImage];

    self.delegate = self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if ([fromVC respondsToSelector:@selector(animatedTransitionFromSelfWithOperation:toVC:)]) {
        id<TTNavigationControllerChildProtocol> VC = (id<TTNavigationControllerChildProtocol>)fromVC;
        id<UIViewControllerAnimatedTransitioning> transition = [VC animatedTransitionFromSelfWithOperation:operation toVC:toVC];
        if (transition) return transition;
    }
    if ([toVC respondsToSelector:@selector(animatedTransitionToSelfWithOperation:fromVC:)]) {
        id<TTNavigationControllerChildProtocol> VC = (id<TTNavigationControllerChildProtocol>)toVC;
        id<UIViewControllerAnimatedTransitioning> transition = [VC animatedTransitionToSelfWithOperation:operation fromVC:fromVC];
        if (transition) return transition;
    }
    if (self.animatedTransitionBlock) {
        id<UIViewControllerAnimatedTransitioning> transition = self.animatedTransitionBlock(operation, fromVC, toVC);
        if (transition) return transition;
    }
    return nil;
}

- (BOOL)tt_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    BOOL shouldPop = YES;

    if (self.topViewController.navigationItem == item && [self.topViewController respondsToSelector:@selector(navigationControllerShouldPopViewController)]) {
        shouldPop = [(id<TTNavigationControllerChildProtocol>)self.topViewController navigationControllerShouldPopViewController];
    }
    if (shouldPop) {
        return [self tt_navigationBar:navigationBar shouldPopItem:item];
    }
    return NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

+ (UIImage *)defaultBackIndicatorImage {
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setDefaultBackIndicatorImage:(UIImage *)defaultBackIndicatorImage {
    objc_setAssociatedObject(self, @selector(defaultBackIndicatorImage), defaultBackIndicatorImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
