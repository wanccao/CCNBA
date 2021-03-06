//
//  WCCDrawerViewController.m
//  封装抽屉
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 wanccao. All rights reserved.
//

#import "WCCDrawerViewController.h"
#import "CCMeViewController.h"
@interface WCCDrawerViewController ()<UIGestureRecognizerDelegate>
{
    UITabBarController *rootVC;
    UIViewController *menuVC;
    BOOL drawerIsOpen;
    UITapGestureRecognizer *tap;
}
@end

@implementation WCCDrawerViewController
//  设置屏幕旋转
- (BOOL)shouldAutorotate{
   // 获取当前的控制器
    UINavigationController *navc = rootVC.selectedViewController;
    UIViewController *currrentVC = navc.visibleViewController;
    // 默认shouldAutorotate是YES  取反:返回为YES的时候不能旋转，返回NO的时候可以旋转
    return !currrentVC.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController menuViewController:(UIViewController *)menuViewController{
    self = [super init];
    if (self) {
        rootVC = (UITabBarController *)rootViewController;
        menuVC = menuViewController;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    menuVC.view.frame = CGRectMake(-100, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:menuVC.view];
    [self addChildViewController:menuVC];
    rootVC.view.frame = self.view.frame;
    [self.view addSubview:rootVC.view];
    [self addChildViewController:rootVC];
    [self addbtn];
#pragma mark //////////////////////////添加手势////////////////////////////
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    tap.enabled = NO;
    [self.view addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:pan];
}
#pragma mark //////////////////////////抽屉按钮方法////////////////////////////
- (void)addbtn{
    UIImage *btn = [[UIImage imageNamed:@"头像Btn"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    NSLog(@"%@",rootVC.viewControllers);
    for (UINavigationController *vc in rootVC.viewControllers) {
        vc.viewControllers.firstObject.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:btn style:(UIBarButtonItemStyleDone) target:self action:@selector(btn)];
    }
}
- (void)btn{
    [self showMenuViewController];
}
#pragma mark //////////////////////////接口实现////////////////////////////
- (void)showRootViewController{
    [self showRootViewControllerAnimationed:YES];
}
- (void)showRootViewControllerAnimationed:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:0.5 animations:^{
            rootVC.view.frame = self.view.frame;
            menuVC.view.frame = CGRectMake(-100, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }else{
        rootVC.view.frame = self.view.frame;
        menuVC.view.frame = CGRectMake(-100, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    tap.enabled = NO;
    rootVC.view.userInteractionEnabled = YES;
}
-(void)showMenuViewController{
    [UIView animateWithDuration:0.5 animations:^{
        rootVC.view.frame = CGRectMake(300, 0, self.view.frame.size.width,self.view.frame.size.height);
        menuVC.view.frame = self.view.frame;
    }];
    rootVC.view.userInteractionEnabled = NO;
    tap.enabled = YES;
}
- (void)showViewController:(UIViewController *)vc animated:(BOOL)yes{
    [self showRootViewControllerAnimationed:NO];
    UINavigationController *nc = (UINavigationController *)rootVC.selectedViewController;
    [nc pushViewController:vc animated:yes];
}
#pragma mark //////////////////////////手势////////////////////////////
- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self showRootViewController];
}
- (void)panAction:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:rootVC.view];
    CGFloat X = rootVC.view.x;
    if (X >= 0 && X <= 300) {
        rootVC.view.x += point.x;
        menuVC.view.x += point.x/3;
    }
    [sender setTranslation:CGPointZero inView:rootVC.view];
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (rootVC.view.frame.origin.x < self.view.frame.size.width / 3) {
            [self showRootViewController];
        }else{
            [self showMenuViewController];
        }
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == tap) {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        if (CGRectContainsPoint(rootVC.view.frame, point)) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}
@end
