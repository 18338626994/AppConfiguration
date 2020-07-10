//
//  LRDialog.h
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "LRAlert.h"
#import "LRToast.h"
#import "LRLoading.h"

@interface LRDialog : NSObject

+ (LRLoading *)showLoading;
+ (LRLoading *)dismissLoading;


+ (LRToast *)showToast:(NSString *)toast;
+ (LRToast *)showToast:(NSString *)toast duration:(double)duration;
+ (LRToast *)showToast:(NSString *)toast duration:(double)duration delay:(double)delay;


+ (LRAlert *)showAlertTitle:(NSString *)title content:(NSString *)content;
+ (LRAlert *)showAlertTitle:(NSString *)title content:(NSString *)content actionTitle:(NSString *)buttonTitle;
+ (LRAlert *)showAlertTitle:(NSString *)title content:(NSString *)content button:(AlertConfig)button callback:(AlertConfig)callback;
+ (LRAlert *)showAlertTitle:(NSString *)title content:(NSString *)content leftButton:(AlertConfig)leftButton rightButton:(AlertConfig)rightButton leftCallback:(AlertConfig)leftCallback rightCallback:(AlertConfig)rightCallback;
+ (LRAlert *)showCustomAlert:(UIView *)customView;


+ (LRAlert *)showSheetTitle:(NSString *)title content:(NSString *)content;
+ (LRAlert *)showSheetTitle:(NSString *)title content:(NSString *)content button:(AlertConfig)button callback:(AlertConfig)callback;
+ (LRAlert *)showSheetTitle:(NSString *)title content:(NSString *)content leftButton:(AlertConfig)leftButton rightButton:(AlertConfig)leftButton leftCallback:(AlertConfig)leftCallback rightCallback:(AlertConfig)leftCallback;
+ (LRAlert *)showCustomSheet:(UIView *)customView;

 
- (LRDialog *)backgroundOpacity:(double)opacity;

// 默认自动为自动隐藏，个别不要自动隐藏的配置后需手动隐藏
- (LRDialog *)autoHiddenAlert:(BOOL)hidden;
- (void)hiddenAlert;

@end
