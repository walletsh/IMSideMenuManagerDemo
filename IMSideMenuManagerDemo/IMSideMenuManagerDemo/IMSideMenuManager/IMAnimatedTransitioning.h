//
//  IMAnimatedTransitioning.h
//  IMSideMenuManager
//
//  Created by imwallet on 2017/12/7.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMSideMenuManager.h"

/*
 主要用于定义切换时的动画。
 */

@interface IMAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) IMSideDirection direction;
@property (nonatomic, assign) IMTransitioningType transitionType;
@property (nonatomic, assign) CGFloat margin;

@end
