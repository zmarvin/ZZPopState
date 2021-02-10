//
//  UIViewController+ZZPopState.h
//  ZZPopState
//
//  Created by ZhangZhan on 2021/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const ZZPopStartNotification;
UIKIT_EXTERN NSString *const ZZPopCancelledNotification;
UIKIT_EXTERN NSString *const ZZPopEndedNotification;

@interface UIViewController (ZZPopState)

@property (nonatomic,assign) BOOL zz_popSateDisabled;

@end

NS_ASSUME_NONNULL_END
