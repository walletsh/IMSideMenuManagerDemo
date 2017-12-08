//
//  IMAnimatedTransitioning.m
//  IMSideMenuManager
//
//  Created by imwallet on 2017/12/7.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import "IMAnimatedTransitioning.h"

@interface IMAnimatedTransitioning ()

@end

static NSTimeInterval kAnimationDuration = 0.25;

@implementation IMAnimatedTransitioning

-(instancetype)init
{
    if (self = [super init]){
        self.direction = IMSideDirectionLeft;
        self.transitionType = IMTransitioningTypePresent;
        NSLog(@"IMAnimatedTransitioning init");
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
//指定转场动画持续的时长
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"%s", __func__);
    return kAnimationDuration;
}

//转场动画的具体内容
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"%s", __func__);
    //获取动画的源控制器和目标控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    switch (self.transitionType) {
            
            case IMTransitioningTypePresent:
            [self animatePresentingWithContext:transitionContext toController:toVC fromController:fromVC];
            break;
            
            case IMTransitioningTypeDismiss:
            [self animateDismissingWithContext:transitionContext toController:toVC fromController:fromVC];
            break;

        default:
            break;
    }
}

#pragma mark - Private method
-(void)animatePresentingWithContext:(id<UIViewControllerContextTransitioning>)transitionContext toController:(UIViewController *)toController fromController:(UIViewController *)fromController
{
    CGRect fromRect = [transitionContext initialFrameForViewController:fromController];
    CGRect toRect = fromRect;
    NSLog(@"%s -- fromRect: %@", __func__, NSStringFromCGRect(fromRect));
    
    switch (self.direction) {
            case IMSideDirectionLeft:{
                toRect.origin.x = -(toRect.size.width - self.margin);// for the edge panGesture
                if (@available(iOS 11, *)) {
                    // it's maybe a bug of iOS 11, it should be checked some time
                    CGFloat fromX = CGRectGetMinX(fromRect) - self.margin;
                    NSLog(@"toRect.origin.x: %f --- fromX: %f", toRect.origin.x, fromX);
                    fromRect = CGRectMake(fromX, CGRectGetMinY(fromRect), fromRect.size.width, fromRect.size.height);
                }
            }
            break;
            
            case IMSideDirectionRight:{
                toRect.origin.x = toRect.size.width - self.margin;
                if (@available(iOS 11, *)) {
                    CGFloat fromX = CGRectGetMinX(fromRect) + self.margin;
                    NSLog(@"toRect.origin.x: %f --- fromX: %f", toRect.origin.x, fromX);
                    fromRect = CGRectMake(fromX, CGRectGetMinY(fromRect), fromRect.size.width, fromRect.size.height);
                }
            }
            break;

        default:
            break;
    }
    
    toController.view.frame = toRect;
    [transitionContext.containerView addSubview:toController.view];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        toController.view.frame = fromRect;
    } completion:^(BOOL finished) {
        if (transitionContext.transitionWasCancelled){
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
        }
    }];
}

-(void)animateDismissingWithContext:(id<UIViewControllerContextTransitioning>)transitionContext toController:(UIViewController *)toController fromController:(UIViewController *)fromController
{
    NSLog(@"%s", __func__);
    CGRect fromRect = [transitionContext initialFrameForViewController:fromController];
    
    switch (self.direction) {
            case IMSideDirectionLeft:
            fromRect.origin.x = -fromRect.size.width;
            break;
            
            case IMSideDirectionRight:
            fromRect.origin.x = fromRect.size.width + self.margin;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        fromController.view.frame = fromRect;
    } completion:^(BOOL finished) {
        if (transitionContext.transitionWasCancelled){
            [transitionContext completeTransition:NO];
        }else{
            if ([toController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navController = (UINavigationController *)toController;
                NSLog(@"childViewControllers: %@", navController.topViewController);
                NSArray *gestureRecognizers = navController.topViewController.view.gestureRecognizers;
                [gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"UIGestureRecognizer obj %@", obj);
                    if ([obj isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                        [navController.topViewController.view removeGestureRecognizer:obj];
                        *stop = YES;
                    }
                }];
            }else{
                NSArray *gestureRecognizers = toController.view.gestureRecognizers;
                [gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"UIGestureRecognizer obj %@", obj);
                    if ([obj isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                        [toController.view removeGestureRecognizer:obj];
                        *stop = YES;
                    }
                }];
            }
            [transitionContext completeTransition:YES];
        }
    }];
}

@end
