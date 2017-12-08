//
//  IMMainViewController.m
//  IMSideMenuManagerDemo
//
//  Created by imwallet on 2017/12/8.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import "IMMainViewController.h"
#import "IMSideMenuManager.h"
#import "IMLeftViewController.h"
#import "IMRightViewController.h"
#import "ViewController.h"

@interface IMMainViewController ()

@property (nonatomic, strong) IMSideMenuManager *leftManager;
@property (nonatomic, strong) IMSideMenuManager *rightManager;
@property (nonatomic, strong) IMLeftViewController *leftVC;
@property (nonatomic, strong) IMRightViewController *rightVC;
@end

@implementation IMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(leftBarItemClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightBarItemClick)];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    button.center = CGPointMake(200, 200);
//    [button addTarget:self action:@selector(leftBarItemClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

-(void)leftBarItemClick
{
    __weak typeof(self) weakSelf = self;
    _leftVC = [[IMLeftViewController alloc] init];
    
    _leftVC.itemDidSelectedBlock = ^(NSInteger index) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *viewController = [storyboard instantiateInitialViewController];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
    
    _leftManager = [[IMSideMenuManager alloc] initWithMainController:self leftController:_leftVC margin:80];

    [self presentViewController:self.leftVC animated:YES completion:nil];
}

-(void)rightBarItemClick
{
    __weak typeof(self) weakSelf = self;

    _rightVC = [[IMRightViewController alloc] init];
    _rightVC.itemDidSelectedBlock = ^(NSInteger index) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *viewController = [storyboard instantiateInitialViewController];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
    _rightManager = [[IMSideMenuManager alloc] initWithMainController:self rightController:_rightVC margin:60];

    [self presentViewController:self.rightVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
