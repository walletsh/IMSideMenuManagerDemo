//
//  IMPresentationController.h
//  IMSideMenuManager
//
//  Created by imwallet on 2017/12/7.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSideMenuManager.h"

@interface IMPresentationController : UIPresentationController

@property (nonatomic, strong) UIView *dimmingView;

@property (nonatomic, assign) IMSideDirection direction;

@property (nonatomic, assign) CGFloat margin;


@end
