//
//  IMPercentDrivenInteractiveTransition.h
//  IMSideMenuManager
//
//  Created by imwallet on 2017/12/7.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSideMenuManager.h"

/*
 负责交互动画的对象。
 该对象是通过加快／减慢动画切换的过程，来响应触发事件或者随时间变化的程序输入。对象也可以提高切换的逆过程来响应变化。
 */

@interface IMPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL isInteractiveTransition;

-(instancetype)initWithController:(UIViewController *)controller view:(UIView *)view presentController:(UIViewController *)presentController direction:(IMSideDirection)direction;

@end
