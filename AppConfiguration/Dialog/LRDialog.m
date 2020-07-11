//
//  LRDialog.m
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "LRDialog.h"

@interface LRDialog()

@property (nonatomic, strong) LEEBaseConfig *alert;

@end;

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

+ (LRDialog *)showAlertTitle:(NSString *)title
                    content:(NSString *)content {
    return [self showAlertTitle:title content:content actionConfig:nil];
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content actionConfig:(LRActionConfig)config {
    return [self showAlertTitle:title content:content opacity:0 actionConfig:config];
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content opacity:(float)opacity actionConfig:(LRActionConfig)actionConfig {
    
    LRDialog *lrRlert = [[LRDialog alloc] init];
    
    lrRlert.alert = [LEEAlert alert];
    
    LEEBaseConfigModel *config = lrRlert.alert.config;
    // 蒙版透明度
    if(opacity > 0) {
        config.LeeBackgroundStyleTranslucent(opacity);
    }
    // 提头
    if(title && title.length > 0) config.LeeTitle(title);
    // 内容
    if(content && content.length > 0) config.LeeContent(content);
    // 交互按钮
    if (!actionConfig) {
        actionConfig = ^(LEEAction * _Nonnull action) {
            action.title = LRActionTextKnown;
            action.font = LRActionFont;
            action.titleColor = LRActionColorBlue;
            //action.textAlignment = NSTextAlignmentCenter;
        };
    }
    config.LeeAddAction(actionConfig);
    
    config.LeeOpenAnimationStyle(LEEAnimationStyleOrientationNone).LeeShow();
    
    return lrRlert;
    
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content leftConfig:(LRActionConfig)leftConfig rightConfig:(LRActionConfig)rightConfig {
    return [self showAlertTitle:title content:content opacity:0 leftConfig:leftConfig rightConfig:rightConfig];
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content opacity:(float)opacity leftConfig:(LRActionConfig)leftConfig rightConfig:(LRActionConfig)rightConfig {
    
    LRDialog *lrRlert = [[LRDialog alloc] init];
    
    lrRlert.alert = [LEEAlert alert];
    
    LEEBaseConfigModel *config = lrRlert.alert.config;
        
    // 蒙版透明度
    if(opacity > 0) {
        config.LeeBackgroundStyleTranslucent(opacity);
    }
    // 提头
    if(title && title.length > 0) config.LeeTitle(title);
    // 内容
    if(content && content.length > 0) config.LeeContent(content);
    // 交互按钮
    if (!leftConfig) {
        leftConfig = ^(LEEAction * _Nonnull action) {
            action.title = LRActionTextCancel;
            action.font = LRActionFont;
            action.titleColor = LRActionColorBlack;
            //action.textAlignment = NSTextAlignmentCenter;
        };
    }
    // 交互按钮
    if (!rightConfig) {
        rightConfig = ^(LEEAction * _Nonnull action) {
            action.title = LRActionTextConfirm;
            action.font = LRActionFont;
            action.titleColor = LRActionColorBlue;
            //action.textAlignment = NSTextAlignmentCenter;
        };
    }
    config.LeeAddAction(leftConfig).LeeAddAction(rightConfig);
    config.LeeOpenAnimationStyle(LEEAnimationStyleOrientationNone).LeeShow();
    
    return lrRlert;
}


+ (LRDialog *)showCustomAlert:(UIView *)customView opacity:(float)opacity{
    
    LRDialog *lrRlert = [[LRDialog alloc] init];
    
    lrRlert.alert = [LEEAlert alert];
    
    LEEBaseConfigModel *config = lrRlert.alert.config;
    
    // 蒙版透明度
    if(opacity > 0) {
        config.LeeBackgroundStyleTranslucent(opacity);
    }
    
    config.LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeCustomView(customView)
    .LeeShow();
        
    return lrRlert;
}


+ (void)dismissAlert {
    [LEEAlert closeWithCompletionBlock:nil];
}


@end
