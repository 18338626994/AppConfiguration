//
//  LRDialog.m
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "LRDialog.h"
#import "LEEAlert.h"

@implementation LRDialog

static LRDialog *_dialog;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dialog = [[LRDialog alloc] init];
    });
    
    return _dialog;
}

+ (LRDialog *)showLoading {
    return _dialog;
}
+ (LRDialog *)dismissLoading {
    return _dialog;
}

+ (LRDialog *)showToast:(NSString *)toast {
    return _dialog;
}
+ (LRDialog *)showToast:(NSString *)toast duration:(double)duration {
    return _dialog;
}
+ (LRDialog *)showToast:(NSString *)toast duration:(double)duration delay:(double)delay {
    return _dialog;
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content {
    return [self showAlertTitle:title content:content leftButton:nil rightButton:nil leftCallback:nil rightCallback:nil];
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle {
    return [self showAlertTitle:title content:content leftButton:^(UIButton *button){
        [button setTitle:[buttonTitle copy] forState:UIControlStateNormal];
        [button setTitle:[buttonTitle copy] forState:UIControlStateHighlighted];
    } rightButton:nil leftCallback:nil rightCallback:nil];
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content button:(AlertConfig)button callback:(AlertConfig)callback {
    
    return [self showAlertTitle:title content:content leftButton:button rightButton:nil leftCallback:callback rightCallback:nil];
}


+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content leftButton:(AlertConfig)leftButton rightButton:(AlertConfig)rightButton leftCallback:(AlertConfig)leftCallback rightCallback:(AlertConfig)rightCallback {
    
    NSAssert((!title && !content), @"标题和内容不能同时为空");
    
    return _dialog;
}

+ (LRDialog *)showCustomAlert:(UIView *)customView {
    return _dialog;
}

+ (LRDialog *)showSheetTitle:(NSString *)title content:(NSString *)content {
    return _dialog;
}

+ (LRDialog *)showSheetTitle:(NSString *)title content:(NSString *)content button:(AlertConfig)button callback:(AlertConfig)callback {
    return _dialog;
}
+ (LRDialog *)showSheetTitle:(NSString *)title content:(NSString *)content leftButton:(AlertConfig)leftButton rightButton:(AlertConfig)rightButton leftCallback:(AlertConfig)leftCallback rightCallback:(AlertConfig)rightCallback {
    return _dialog;
}
+ (LRDialog *)showCustomSheet:(UIView *)customView {
    return _dialog;
}

@end
