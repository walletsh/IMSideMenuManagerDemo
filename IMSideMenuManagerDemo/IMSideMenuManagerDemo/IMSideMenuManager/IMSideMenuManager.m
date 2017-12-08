//
//  IMSideMenuManager.m
//  IMSideMenuManager
//
//  Created by imwallet on 2017/12/7.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import "IMSideMenuManager.h"
#import "IMPercentDrivenInteractiveTransition.h"
#import "IMAnimatedTransitioning.h"
#import "IMPresentationController.h"


@interface IMSideMenuManager () <UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate>

@property (nonatomic, strong) UIViewController *mainController;
@property (nonatomic, strong) UIViewController *presentController;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) IMSideDirection direction;

@property (nonatomic, strong) IMPercentDrivenInteractiveTransition *presentInteractor;
@property (nonatomic, strong) IMPercentDrivenInteractiveTransition *dismissInteractor;

@end

@implementation IMSideMenuManager

-(instancetype)initWithMainController:(UIViewController *)mainController leftController:(UIViewController *)leftController
{
    return [self initWithMainController:mainController leftController:leftController margin:60];
}

-(instancetype)initWithMainController:(UIViewController *)mainController rightController:(UIViewController *)rightController
{
    return [self initWithMainController:mainController rightController:rightController margin:60];
}

-(instancetype)initWithMainController:(UIViewController *)mainController leftController:(UIViewController *)leftController margin:(CGFloat)margin
{
    if(self = [super init]){
        
        self.mainController = mainController;
        self.presentController = leftController;
        self.direction = IMSideDirectionLeft;
        self.margin = margin;
        
        NSAssert((margin > 0 && margin < [UIScreen mainScreen].bounds.size.width), @"margin is Beyond the scope");

        [self configPresent];
    }
    return self;
}

-(instancetype)initWithMainController:(UIViewController *)mainController rightController:(UIViewController *)rightController  margin:(CGFloat)margin
{
    if(self = [super init]){
        
        self.mainController = mainController;
        self.presentController = rightController;
        self.direction = IMSideDirectionRight;
        self.margin = margin;
        
        NSAssert((margin > 0 && margin < [UIScreen mainScreen].bounds.size.width), @"margin is Beyond the scope");
        
        [self configPresent];
    }
    return self;
}

-(void)configPresent
{
    NSLog(@"%s", __func__);

    self.presentController.transitioningDelegate = self;
    self.presentController.modalPresentationStyle = UIModalPresentationCustom;
    
    self.presentInteractor = [[IMPercentDrivenInteractiveTransition alloc] initWithController:self.mainController view:self.mainController.view presentController:self.presentController direction:self.direction];
}

/*
 用于支持自定义切换或切换交互，定义了一组供animator对象实现的协议，来自定义切换。
 可以为动画的三个阶段单独提供animator对象：presenting，dismissing，interacting。
 */
#pragma mark - UIViewControllerTransitioningDelegate
-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    NSLog(@"%s", __func__);

    IMPresentationController *presentVC = [[IMPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentVC.delegate = self;
    presentVC.direction = self.direction;
    presentVC.margin = self.margin;
    
    self.dismissInteractor = [[IMPercentDrivenInteractiveTransition alloc] initWithController:self.presentController view:presentVC.dimmingView presentController:nil direction:self.direction];
    
    return presentVC;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NSLog(@"%s", __func__);

    IMAnimatedTransitioning *animator = [[IMAnimatedTransitioning alloc] init];
    animator.direction = self.direction;
    animator.transitionType = IMTransitioningTypeDismiss;
    animator.margin = self.margin;
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    NSLog(@"%s", __func__);

    IMAnimatedTransitioning *animator = [[IMAnimatedTransitioning alloc] init];
    animator.direction = self.direction;
    animator.transitionType = IMTransitioningTypePresent;
    animator.margin = self.margin;
    return animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    NSLog(@"%s", __func__);

    return self.dismissInteractor.isInteractiveTransition ? self.dismissInteractor : nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    NSLog(@"%s", __func__);

    return self.presentInteractor.isInteractiveTransition ? self.presentInteractor : nil;
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    NSLog(@"%s", __func__);

    return self.mainController.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? UIModalPresentationOverFullScreen : UIModalPresentationNone;
}
@end
