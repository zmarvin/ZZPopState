//
//  UIViewController+ZZPopState.h
//  ZZPopState
//
//  Created by ZhangZhan on 2021/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const ZZScreenEdgePopGestureStartNotification;
extern NSString *const ZZScreenEdgePopGestureCancelledNotification;
extern NSString *const ZZScreenEdgePopGestureEndedNotification;

@interface UIViewController (ZZPopState)

@property (nonatomic,assign) BOOL zz_popSateDisabled;

@end

NS_ASSUME_NONNULL_END
