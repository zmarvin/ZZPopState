//
//  ViewController.m
//  ZZPopStateDemo
//
//  Created by ZhangZhan on 2021/2/7.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "UIViewController+ZZPopState.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* 尝试用手势pop，对比效果更明显 */
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"开启效果" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(enableEffectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"没有效果" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(100, 350, 100, 100);
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 addTarget:self action:@selector(disableEffectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (void)enableEffectBtnClick{
    ViewController2 *vc2 = [ViewController2 new];
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (void)disableEffectBtnClick{
    ViewController2 *vc2 = [ViewController2 new];
    vc2.zz_popSateDisabled = YES;
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

@end
