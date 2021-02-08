//
//  UIViewController+ZZPopState.h
//  ZZPopState
//
//  Created by ZhangZhan on 2021/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const ZZScreenEdgePopGestureStartNotification;
UIKIT_EXTERN NSString *const ZZScreenEdgePopGestureCancelledNotification;
UIKIT_EXTERN NSString *const ZZScreenEdgePopGestureEndedNotification;

@interface UIViewController (ZZPopState)

@property (nonatomic,assign) BOOL zz_popSateDisabled;

@end

NS_ASSUME_NONNULL_END
