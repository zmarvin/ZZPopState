//
//  UIViewController+ZZPopState.m
//  ZZPopState
//
//  Created by ZhangZhan on 2021/1/30.
//

#import "UIViewController+ZZPopState.h"
#import <objc/runtime.h>

NSString *const ZZPopStartNotification = @"ZZPopStartNotification";
NSString *const ZZPopCancelledNotification = @"ZZPopCancelledNotification";
NSString *const ZZPopEndedNotification = @"ZZPopEndedNotification";

void zz_swizzleIdenticalClassInstanceMethod(Class identicalCls,SEL origSelector, SEL newSelector){
 
    Method originalMethod = class_getInstanceMethod(identicalCls, origSelector);
    Method swizzledMethod = class_getInstanceMethod(identicalCls, newSelector);
 
    BOOL didAddMethod = class_addMethod(identicalCls,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(identicalCls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void zz_swizzleDifferentClassInstanceMethod(Class originalCls,Class swizzledCls,SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(originalCls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledCls, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(originalCls,
                                        swizzledSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        method_exchangeImplementations(originalMethod, class_getInstanceMethod(originalCls, swizzledSelector));
    } else {
        NSLog(@"ZZPopState:%@交换%@失败",originalCls,swizzledCls);
    }
}

@implementation UIViewController (ZZPopState)

static UIImageView *snapshotImageView;
static UIView *barBackground;
static NSObject <UIViewControllerAnimatedTransitioning> *transition;

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        zz_swizzleIdenticalClassInstanceMethod(class, @selector(willMoveToParentViewController:), @selector(zz_willMoveToParentViewController_InjectPopGestureState:));
        zz_swizzleIdenticalClassInstanceMethod(class, @selector(didMoveToParentViewController:), @selector(zz_didMoveToParentViewController_InjectPopGestureState:));
        zz_swizzleIdenticalClassInstanceMethod(class, @selector(viewDidAppear:), @selector(zz_viewDidAppear_InjectPopGestureState:));
        
        [NSNotificationCenter.defaultCenter addObserverForName:ZZPopStartNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            UIViewController *vc = note.object;
            if (vc.zz_popSateDisabled) { return;}
            UINavigationController *navVC = vc.navigationController;
            if (navVC.zz_popSateDisabled){ return;}
            UINavigationBar *navBar = navVC.navigationBar;
            if (navBar.isHidden){ return;}
            id  _UINavigationParallaxTransition = [navVC valueForKeyPath:@"_cachedTransitionController"];
            if (!_UINavigationParallaxTransition) { return;}
            if (transition == nil || transition != _UINavigationParallaxTransition) {
                transition = _UINavigationParallaxTransition;
                zz_swizzleDifferentClassInstanceMethod([transition class], [self class], NSSelectorFromString(@"animateTransition:"), @selector(zz_animateTransition:));
            }
            
            barBackground = [navBar.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [evaluatedObject isKindOfClass:NSClassFromString(@"_UIBarBackground")];
            }]].firstObject;

            UIView *barContentView = [navBar.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [evaluatedObject isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")];
            }]].firstObject;
            
            CGFloat barContentViewH = barContentView.bounds.size.height;
            CGFloat barContentViewY = barBackground.bounds.size.height - barContentViewH;
            CGFloat barContentViewW = barContentView.bounds.size.width;
            
            UIGraphicsBeginImageContextWithOptions(barBackground.bounds.size, YES, 0);
            [barBackground drawViewHierarchyInRect:barBackground.bounds afterScreenUpdates:NO];
            [barContentView drawViewHierarchyInRect:CGRectMake(0, barContentViewY, barContentViewW, barContentViewH) afterScreenUpdates:NO];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            snapshotImageView = [[UIImageView alloc] initWithImage:image];
            UIWindow *keyWindow = [[UIApplication sharedApplication] windows].firstObject;
            snapshotImageView.frame = [navBar convertRect:barBackground.frame toView:keyWindow];
            [keyWindow addSubview:snapshotImageView];
            
        }];
        
        [NSNotificationCenter.defaultCenter addObserverForName:ZZPopCancelledNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [snapshotImageView removeFromSuperview];
            snapshotImageView = nil;
        }];
        
        [NSNotificationCenter.defaultCenter addObserverForName:ZZPopEndedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [snapshotImageView removeFromSuperview];
            snapshotImageView = nil;
        }];
        
    });
    
}

- (void)zz_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    [self zz_animateTransition:transitionContext];
    SEL getDurationSelector = @selector(transitionDuration:);
    NSTimeInterval duration = 0.35;
    if ([self respondsToSelector:getDurationSelector]) {
        NSMethodSignature *signature = [self methodSignatureForSelector:getDurationSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:getDurationSelector];
        [invocation invoke];
        [invocation getReturnValue:&duration];
    }
    
    if (transitionContext.isInteractive) {
        [UIView animateWithDuration:duration delay:0 options: UIViewAnimationOptionCurveLinear animations:^{
            snapshotImageView.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width, snapshotImageView.frame.origin.y, snapshotImageView.frame.size.width, barBackground.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:duration delay:0 options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionCurveEaseOut | (NSUInteger)kCAMediaTimingFunctionEaseInEaseOut animations:^{
            snapshotImageView.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width, snapshotImageView.frame.origin.y, snapshotImageView.frame.size.width, barBackground.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}

static bool isStartPopGesture = NO;
static bool isPopGestureCancelled = NO;

- (void)zz_willMoveToParentViewController_InjectPopGestureState:(UIViewController *)parent{
    [self zz_willMoveToParentViewController_InjectPopGestureState:parent];
    if (!parent) { // 开启pop
        isPopGestureCancelled = NO;
        isStartPopGesture = YES;
        [NSNotificationCenter.defaultCenter postNotificationName:ZZPopStartNotification object:self];
    }
}

- (void)zz_didMoveToParentViewController_InjectPopGestureState:(UIViewController *)parent{
    [self zz_didMoveToParentViewController_InjectPopGestureState:parent];
    if (!parent) { // pop结束
        isPopGestureCancelled = NO;
        isStartPopGesture = NO;
        [NSNotificationCenter.defaultCenter postNotificationName:ZZPopEndedNotification object:self];
    }
}

- (void)zz_viewDidAppear_InjectPopGestureState:(BOOL)animated{
    [self zz_viewDidAppear_InjectPopGestureState:animated];
    if (isStartPopGesture) {// pop取消
        isPopGestureCancelled = YES;
        isStartPopGesture = NO;
        [NSNotificationCenter.defaultCenter postNotificationName:ZZPopCancelledNotification object:self];
    }
}

- (BOOL)zz_popSateDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZz_popSateDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(zz_popSateDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
