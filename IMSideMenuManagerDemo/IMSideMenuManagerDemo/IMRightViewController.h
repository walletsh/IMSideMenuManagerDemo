//
//  IMRightViewController.h
//  IMSideMenuManagerDemo
//
//  Created by imwallet on 2017/12/8.
//  Copyright © 2017年 imWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ViewItemDidSelectedBlock)(NSInteger index);

@interface IMRightViewController : UIViewController

@property (nonatomic, copy) ViewItemDidSelectedBlock itemDidSelectedBlock;

@end
