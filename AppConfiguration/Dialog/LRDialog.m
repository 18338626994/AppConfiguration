//
//  LRDialog.m
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "LRDialog.h"
#import "MBProgressHUD.h"

@interface LRDialog()

@property (nonatomic, assign) NSUInteger loadingCounter;
@property (nonatomic, strong) LEEBaseConfig *baseConfig;
@property (nonatomic, strong) MBProgressHUD *loadingHUD;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *identifier = [NSString stringWithFormat:@"<LRDialogLoadingQueue>%p",self];
        _concurrentQueue = dispatch_queue_create([identifier UTF8String], DISPATCH_QUEUE_CONCURRENT);
        _loadingCounter = 0;
    }
    return self;
}

#pragma mark - Loading


+ (void)showLoading {
    
    dispatch_barrier_async([LRDialog sharedInstance].concurrentQueue, ^{
        // 初始化_dialog
        _dialog.loadingCounter ++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!_dialog.loadingHUD.superview) {
                [[self mainWindow] addSubview:_dialog.loadingHUD];
                [_dialog.loadingHUD showAnimated:YES];
                //[_dialog.loadingHUD show:YES];
            }
        });
    });
}

+ (void)dismissLoading {
    
    dispatch_barrier_async([LRDialog sharedInstance].concurrentQueue, ^{
        // 自减
        _dialog.loadingCounter --;
        
        if(_dialog.loadingCounter <= 0) {
            _dialog.loadingCounter = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_dialog.loadingHUD hideAnimated:YES afterDelay:0.1];
                //[_dialog.loadingHUD hide:YES afterDelay:0.1];
            });
        }
    });
}

+ (void)forceDismissAllLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        _dialog.loadingCounter = 0;
        //[_dialog.loadingHUD hide:YES];
        [_dialog.loadingHUD hideAnimated:YES];
    });
}

#pragma mark - Toast

+ (LRDialog *)showToast:(NSString *)toast {
    return [self showToast:toast duration:1.5];
}

+ (LRDialog *)showToast:(NSString *)toast duration:(double)duration {
    return [self showToast:toast duration:duration delay:0.5];
}

+ (LRDialog *)showToast:(NSString *)toast duration:(double)duration delay:(double)delay {
    
    UIWindow *window = [self mainWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    hud.label.text = toast;
    //hud.labelText = toast;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    // 文本色
    //hud.contentColor = [UIColor redColor];
    // 蒙层背景色
    //hud.backgroundColor = [UIColor yellowColor];
    // MaskViewM背景色
    //hud.bezelView.backgroundColor = [UIColor greenColor];
    
    [hud showAnimated:YES];
    //[hud show:YES];
    [window addSubview:hud];
    
    duration = duration <= 0.5 ? 1.5 : duration;
    
    [hud hideAnimated:YES afterDelay:duration];
    //[hud hide:YES afterDelay:duration];
    
    return _dialog;
    
}

#pragma mark - Alert
+ (LRDialog *)showAlertTitle:(NSString *)title
                    content:(NSString *)content {
    return [self showAlertTitle:title content:content actionConfig:nil];
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content actionConfig:(LRActionConfig)config {
    return [self showAlertTitle:title content:content opacity:0 actionConfig:config];
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content opacity:(float)opacity actionConfig:(LRActionConfig)actionConfig {
    
    LRDialog *lrAlert = [[LRDialog alloc] init];
    
    lrAlert.baseConfig = [LEEAlert alert];
    
    LEEBaseConfigModel *config = lrAlert.baseConfig.config;
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
    
    return lrAlert;
    
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content leftConfig:(LRActionConfig)leftConfig rightConfig:(LRActionConfig)rightConfig {
    return [self showAlertTitle:title content:content opacity:0 leftConfig:leftConfig rightConfig:rightConfig];
}

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content opacity:(float)opacity leftConfig:(LRActionConfig)leftConfig rightConfig:(LRActionConfig)rightConfig {
    
    LRDialog *lrAlert = [[LRDialog alloc] init];
    
    lrAlert.baseConfig = [LEEAlert alert];
    
    LEEBaseConfigModel *config = lrAlert.baseConfig.config;
        
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
    
    return lrAlert;
}


+ (LRDialog *)showCustomAlert:(UIView *)customView opacity:(float)opacity{
    
    LRDialog *lrAlert = [[LRDialog alloc] init];
    
    lrAlert.baseConfig = [LEEAlert alert];
    
    LEEBaseConfigModel *config = lrAlert.baseConfig.config;
    
    // 蒙版透明度
    if(opacity > 0) {
        config.LeeBackgroundStyleTranslucent(opacity);
    }
    
    config.LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeCustomView(customView)
    .LeeShow();
        
    return lrAlert;
}


+ (void)dismissAlert {
    [LEEAlert closeWithCompletionBlock:nil];
}


#pragma mark - Action Sheet
+ (LRDialog *)showSheetTitle:(NSString *)title content:(NSString *)content {
    
    return [self showAlertTitle:title content:content actionConfig:nil];
}

+ (LRDialog *)showSheetTitle:(NSString *)title content:(NSString *)content actionConfig:(LRActionConfig)actionConfig {
    return [self showSheetTitle:nil content:nil actionConfigs:nil cancelConfig:actionConfig];
}

+ (LRDialog *)showSheetActionConfigs:(NSArray <LRActionConfig>*)actionConfigs cancelConfig:(LRActionConfig)cancelConfig {
    return [self showSheetTitle:nil content:nil actionConfigs:actionConfigs cancelConfig:cancelConfig];
}

+ (LRDialog *)showSheetTitle:(NSString *)title content:(NSString *)content actionConfigs:(NSArray <LRActionConfig>*)actionConfigs cancelConfig:(LRActionConfig)cancelConfig {
    
    LRDialog *lrSheet = [[LRDialog alloc] init];
    
    lrSheet.baseConfig = [LEEAlert actionsheet];
    
    LEEBaseConfigModel *config = lrSheet.baseConfig.config;
    
    // 提头
    if(title && title.length > 0) config.LeeTitle(title);
    
    // 内容
    if(content && content.length > 0) config.LeeContent(content);
    
    // 交互按钮
    if (actionConfigs && actionConfigs.count > 0) {
        for (int i = 0; i < actionConfigs.count; i ++) {
            LRActionConfig actionConfig = actionConfigs[i];
            config.LeeAddAction(actionConfig);
        }
    }
    
    LEEAction *cancelAction = [[LEEAction alloc] init];
    cancelAction.title = LRActionTextConfirm;
    cancelAction.titleColor = LRActionColorBlue;
    
    if (cancelConfig) {
        cancelConfig(cancelAction);
    }
    
    config.LeeCancelAction(cancelAction.title, cancelAction.clickBlock);
    config.LeeShow();
    
    return lrSheet;
}

+ (LRDialog *)showCustomSheet:(UIView *)customView opacity:(float)opacity {
    
    LRDialog *lrSheet = [[LRDialog alloc] init];
    
    lrSheet.baseConfig = [LEEAlert actionsheet];
    
    LEEBaseConfigModel *config = lrSheet.baseConfig.config;
    
    // 蒙版透明度
    if(opacity > 0) {
        config.LeeBackgroundStyleTranslucent(opacity);
    }
    
    config.LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeCustomView(customView)
    .LeeShow();
        
    return lrSheet;
    
}



#pragma mark - Getter

- (MBProgressHUD *)loadingHUD {
    if(_loadingHUD == nil){
        // view仅用于设置BackgroundView的frame
        _loadingHUD = [[MBProgressHUD alloc] initWithView:[LRDialog mainWindow]];
        _loadingHUD.mode = MBProgressHUDModeIndeterminate;
        _loadingHUD.removeFromSuperViewOnHide = YES;
        
        // 蒙层背景色
        _loadingHUD.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        // MaskViewM背景色
        // _loadingHUD.bezelView.backgroundColor = [UIColor greenColor];
        
    }
    return _loadingHUD;
}

+ (UIWindow *)mainWindow {
    
    UIWindow *tempWindow = nil;
    
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        /*
        BOOL isKeyWindow = window.isKeyWindow;
        BOOL isWindow = [window isKindOfClass:UIWindow.class];
        BOOL isNormalLevel = window.windowLevel == UIWindowLevelNormal;
        */
        if (window.isKeyWindow) tempWindow = window;
    }
    
    if (!tempWindow) {
        tempWindow = [UIApplication.sharedApplication.windows lastObject];
    }
    
    return tempWindow;
}

@end

