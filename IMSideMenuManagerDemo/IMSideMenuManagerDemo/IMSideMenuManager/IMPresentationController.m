//
//  IMPresentationController.m
//  IMSideMenuManager
//
//  Created by imwallet on 2017/12/7.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import "IMPresentationController.h"

@interface IMPresentationController ()

@end


@implementation IMPresentationController

-(CGRect)frameOfPresentedViewInContainerView
{
    NSLog(@"%s", __func__);

    CGRect frame = [super frameOfPresentedViewInContainerView];
    
    if(self.direction == IMSideDirectionRight){
        frame.origin.x = self.margin;
    }
    
    frame.size = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:self.containerView.bounds.size];
    return frame;
}

-(void)containerViewWillLayoutSubviews
{
    NSLog(@"%s", __func__);

    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

-(CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    NSLog(@"%s -- %@", __func__, NSStringFromCGSize(parentSize));

    CGFloat width = parentSize.width - self.margin;
    return CGSizeMake(width, parentSize.height);
}

-(void)presentationTransitionWillBegin
{
    NSLog(@"%s", __func__);

    [self.containerView insertSubview:self.dimmingView atIndex:0];
    NSArray *VConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimmingView]|" options:0 metrics:nil views:@{@"dimmingView": self.dimmingView}];
    [NSLayoutConstraint activateConstraints:VConstraintArray];
    
    NSArray *HConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dimmingView]|" options:0 metrics:nil views:@{@"dimmingView": self.dimmingView}];
    [NSLayoutConstraint activateConstraints:HConstraintArray];
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentedViewController.transitionCoordinator;
    if(!coordinator){
        self.dimmingView.alpha = 1.0;
        return;
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 1.0;
    } completion:nil];
}

-(void)dismissalTransitionWillBegin
{
    NSLog(@"%s", __func__);

    id<UIViewControllerTransitionCoordinator> coordinator = self.presentedViewController.transitionCoordinator;
    if(!coordinator){
        self.dimmingView.alpha = 0.0;
        return;
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.0;
    } completion:nil];
}


-(UIView *)dimmingView
{
    if(!_dimmingView){
        _dimmingView = [[UIView alloc] init];
        _dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _dimmingView.alpha = 0;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDimmingView:)];
        [_dimmingView addGestureRecognizer:tapGR];
    }
    return _dimmingView;
}

-(void)handleTapDimmingView:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"%s", __func__);

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
