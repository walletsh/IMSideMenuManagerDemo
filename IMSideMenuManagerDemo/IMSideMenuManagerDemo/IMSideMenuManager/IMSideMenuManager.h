//
//  IMSideMenuManager.h
//  IMSideMenuManager
//
//  Created by imwallet on 2017/12/7.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMSideDirection) {
    IMSideDirectionLeft,
    IMSideDirectionRight
};

typedef NS_ENUM(NSInteger, IMTransitioningType) {
    IMTransitioningTypePresent,
    IMTransitioningTypeDismiss
};

@interface IMSideMenuManager : NSObject

/**
 左侧抽屉 默认右间距 60
 */
-(instancetype)initWithMainController:(UIViewController *)mainController leftController:(UIViewController *)leftController;

/**
 右侧抽屉 默认左间距 60
 */
-(instancetype)initWithMainController:(UIViewController *)mainController rightController:(UIViewController *)rightController;


/**
 左侧抽屉
 @param margin 右间距
 */
-(instancetype)initWithMainController:(UIViewController *)mainController leftController:(UIViewController *)leftController margin:(CGFloat)margin;


/**
 右侧抽屉
 @param margin 左间距
 */
-(instancetype)initWithMainController:(UIViewController *)mainController rightController:(UIViewController *)rightController  margin:(CGFloat)margin;


@end
