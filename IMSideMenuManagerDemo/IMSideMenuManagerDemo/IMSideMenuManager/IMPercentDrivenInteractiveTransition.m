//
//  IMPercentDrivenInteractiveTransition.m
//  IMSideMenuManager
//
//  Created by imwallet on 2017/12/7.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import "IMPercentDrivenInteractiveTransition.h"

@interface IMPercentDrivenInteractiveTransition ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) UIViewController *presentController;
@property (nonatomic, assign) IMSideDirection direction;
@property (nonatomic, assign) BOOL shouldComplete;

@end

@implementation IMPercentDrivenInteractiveTransition

-(instancetype)initWithController:(UIViewController *)controller view:(UIView *)view presentController:(UIViewController *)presentController direction:(IMSideDirection)direction
{
    NSLog(@"%s", __func__);

    if (self = [super init]){
        
        self.controller = controller;
        self.presentController = presentController;
        self.direction = direction;
        self.shouldComplete = NO;
        self.isInteractiveTransition = NO;
        
        if(presentController){
            switch (direction) {
                    case IMSideDirectionLeft:{
                        UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGestureHander:)];
                        edgePanGesture.edges = UIRectEdgeLeft;
                        edgePanGesture.delegate = self;
                        [self.controller.view addGestureRecognizer:edgePanGesture];
                    }
                    break;
                    
                    case IMSideDirectionRight:{
                        UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGestureHander:)];
                        edgePanGesture.edges = UIRectEdgeRight;
                        edgePanGesture.delegate = self;
                        [self.controller.view addGestureRecognizer:edgePanGesture];
                    }
                    break;

                default:
                    break;
            }
        }else{
            UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGestureHander:)];
            [view addGestureRecognizer:panGR];
            
            UIPanGestureRecognizer *dismissPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGestureHander:)];
            [self.controller.view addGestureRecognizer:dismissPanGR];
        }
    }
    return self;
}

#pragma mark - Event Action
-(void)edgePanGestureHander:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"%s", __func__);

    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    
    UIGestureRecognizerState state = recognizer.state;
    switch (state) {
            case UIGestureRecognizerStateBegan:{
                self.isInteractiveTransition = YES;
                if (self.presentController){
                    [self.controller presentViewController:self.presentController animated:YES completion:nil];
                }else{
                    [self.controller dismissViewControllerAnimated:YES completion:nil];
                }
            }
            break;
            
            case UIGestureRecognizerStateChanged:{
                CGFloat screenWidth = -[UIScreen mainScreen].bounds.size.width;
                CGFloat dragAmount = !self.presentController ? screenWidth : -screenWidth;
                switch (self.direction) {
                        case IMSideDirectionLeft:
                        dragAmount = !self.presentController ? screenWidth : -screenWidth;
                        break;
                        
                        case IMSideDirectionRight:
                        dragAmount = self.presentController ? screenWidth : -screenWidth;
                        break;
                    default:
                        break;
                }
                CGFloat threshold = 0.20;
                CGFloat percent = translation.x / dragAmount;
                percent = MAX(percent, 0.0);
                percent = MIN(percent, 1.0);
                [self updateInteractiveTransition:percent];
                self.shouldComplete = percent > threshold;
            }
            break;
            
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
        {
            self.isInteractiveTransition = NO;
            if (self.shouldComplete == NO || state == UIGestureRecognizerStateCancelled){
                [self cancelInteractiveTransition];
            }else{
                [self finishInteractiveTransition];
            }
        }
            break;

        default:
            break;
    }
}


#pragma mrk - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s", __func__);

    if ([self.controller isKindOfClass:[UINavigationController class]]){
        UINavigationController *navController = (UINavigationController *)self.controller;
        return navController.childViewControllers.count < 2;
    }
    return YES;
}

@end
