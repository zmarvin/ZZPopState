//
//  ViewController.m
//  ZZPopStateDemo
//
//  Created by ZhangZhan on 2021/2/7.
//

#import "ViewController.h"
#import "ViewController2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 100, 100);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)push{
    ViewController2 *vc2 = [ViewController2 new];
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

@end
