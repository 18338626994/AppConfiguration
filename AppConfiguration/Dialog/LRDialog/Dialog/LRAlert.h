//
//  LRAlert.h
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEEAlert.h"
#import "LRDialogHelper.h"

@interface LRAlert : NSObject

+ (LRAlert *)showAlertTitle:(NSString *)title
                    content:(NSString *)content;

+ (LRAlert *)showAlertTitle:(NSString *)title
                    content:(NSString *)content
                 actionText:(NSString *)text;

+ (LRAlert *)showAlertTitle:(NSString *)title
                    content:(NSString *)content
                actionLabel:(UILabel *)item
                   callback:(LRCallback)callback;

+ (LRAlert *)showAlertTitle:(NSString *)title
                    content:(NSString *)content
            leftActionLabel:(UILabel *)leftItem
               leftCallback:(LRCallback)leftCallback
            leftActionLabel:(UILabel *)rightItem
              rightCallback:(LRCallback)rightCallback;

+ (LRAlert *)showCustomAlert:(UIView *)customView;


+ (LRAlert *)showCustomSheet:(UIView *)customView;

/*
 * 可以配置Loading、Toast、Alert的background透明度
 * 默认为：
 *  Loading: 0.4
 *  Toast:   0.6
 *  Alert:   0.0
 *  Sheet:   0.0
 *
 */
- (LRAlert *)backgroundOpacity:(double)opacity;

// 默认自动为自动隐藏，个别不要自动隐藏的配置后需手动隐藏
- (LRAlert *)autoHidden:(BOOL)hidden;

- (void)hidden;

@end

