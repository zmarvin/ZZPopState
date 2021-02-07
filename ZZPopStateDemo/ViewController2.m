//
//  ViewController2.m
//  ZZPopStateDemo
//
//  Created by ZhangZhan on 2021/2/7.
//

#import "ViewController2.h"
#import "UIViewController+ZZPopState.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
//    self.zz_popSateDisabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *image = [[UIImage imageNamed:@"test.jpg"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

@end
