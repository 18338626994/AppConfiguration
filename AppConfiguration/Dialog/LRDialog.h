//
//  LRDialog.h
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEEAlert.h"
#import "LRDialogHelper.h"

typedef void(^LRActionConfig)(LEEAction *action);

@interface LRDialog : NSObject

//TODO: Loading
+ (void)showLoading;
+ (void)dismissLoading;
+ (void)forceDismissAllLoading;

//TODO: Toast
+ (LRDialog *)showToast:(NSString *)toast;
+ (LRDialog *)showToast:(NSString *)toast duration:(double)duration;
+ (LRDialog *)showToast:(NSString *)toast duration:(double)duration delay:(double)delay;


//TODO: Alert
/**
 * 单按钮默认Alert样式--蓝色“知道了”按钮，点击无回调
 * @param title       弹框标题
 * @param content   弹框内容
 * @return LRDialog
*/
+ (LRDialog *)showAlertTitle:(NSString *)title
                    content:(NSString *)content;

/**
 * 单按钮默认Alert样式--蓝色“知道了”按钮，可配置：按钮文字、字体、颜色和富文本等和事件回调
 * @param title       弹框标题
 * @param content   弹框内容
 * @param config     按钮配置
 * @return LRDialog
*/
+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content actionConfig:(LRActionConfig)config;

/**
 * 单按钮默认Alert样式--蓝色“知道了”按钮，可配置：按钮文字、字体、颜色和富文本等和蒙层透明度、事件回调
 * @param title                 弹框标题
 * @param content             弹框内容
 * @param opacity             蒙层透明度
 * @param actionConfig  按钮配置
 * @return LRDialog
*/
+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content opacity:(float)opacity actionConfig:(LRActionConfig)actionConfig;

/**
 * 双按钮默认Alert样式--灰色“取消” | 蓝色“知道了”，可配置：左右按钮文字、字体、颜色和富文本等和事件回调
 * @param title              弹框标题
 * @param content          弹框内容
 * @param leftConfig   左按钮配置
 * @param rightConfig 右按钮配置
 * @return LRDialog
*/
+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content leftConfig:(LRActionConfig)leftConfig rightConfig:(LRActionConfig)rightConfig;

/**
 * 双按钮默认Alert样式--灰色“取消” | 蓝色“知道了”，可配置：左右按钮文字、字体、颜色和富文本、事件回调等和蒙层透明度
 * @param title              弹框标题
 * @param content          弹框内容
 * @param opacity          蒙层透明度
 * @param leftConfig   左按钮配置
 * @param rightConfig 右按钮配置
 * @return LRDialog
*/

+ (LRDialog *)showAlertTitle:(NSString *)title content:(NSString *)content opacity:(float)opacity leftConfig:(LRActionConfig)leftConfig rightConfig:(LRActionConfig)rightConfig;

/**
 * 自定义Alert无默认样式，可配置自定义视图和蒙层透明度
 * @param customView   自定义视图
 * @param opacity          蒙层透明度
 *
 * @return LRDialog
*/
+ (LRDialog *)showCustomAlert:(UIView *)customView opacity:(float)opacity;

+ (void)dismissAlert;


//TODO: ActionSheet
/**
 * 双按钮默认ActionSheet样式--蓝色“确认”，可配置：标题、内容
 * @param title                   弹框标题
 * @param content               弹框内容
 * @return LRDialog
*/
+ (LRDialog *)showSheetTitle:(NSString *)title
                     content:(NSString *)content;

/**
 * 双按钮默认ActionSheet样式--灰色“取消” | 蓝色“知道了”，可配置：多按钮文字、字体、颜色和富文本、事件回调
 * @param title                   弹框标题
 * @param content               弹框内容
 * @param actionConfig   多按钮配置
 * @return LRDialog
*/
+ (LRDialog *)showSheetTitle:(NSString *)title
                     content:(NSString *)content
                actionConfig:(LRActionConfig)actionConfig;

/**
 * 双按钮默认ActionSheet样式--灰色“取消” | 蓝色“知道了”，可配置：多按钮文字、字体、颜色和富文本、事件回调
 * @param actionConfigs  多按钮配置
 * @param cancelConfig    底部按钮配置
 * @return LRDialog
*/
+ (LRDialog *)showSheetActionConfigs:(NSArray <LRActionConfig>*)actionConfigs
                        cancelConfig:(LRActionConfig)cancelConfig;

/**
 * 双按钮默认ActionSheet样式--灰色“取消” | 蓝色“知道了”，可配置：多按钮文字、字体、颜色和富文本、事件回调
 * @param title                   弹框标题
 * @param content               弹框内容
 * @param actionConfigs  多按钮配置
 * @param cancelConfig    底部按钮配置
 * @return LRDialog
*/
+ (LRDialog *)showSheetTitle:(NSString *)title
                     content:(NSString *)content
               actionConfigs:(NSArray <LRActionConfig>*)actionConfigs
                cancelConfig:(LRActionConfig)cancelConfig;

/**
 * 自定义ActionSheet无默认样式，可配置自定义视图和蒙层透明度
 * @param customView   自定义视图
 * @param opacity          蒙层透明度
 *
 * @return LRDialog
*/
+ (LRDialog *)showCustomSheet:(UIView *)customView
                      opacity:(float)opacity;

@end
