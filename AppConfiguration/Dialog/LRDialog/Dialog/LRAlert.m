//
//  LRAlert.m
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "LRAlert.h"

@interface LRAlert()

@property (nonatomic, weak) LEEBaseConfigModel *config;

@end;

@implementation LRAlert

+ (LRAlert *)showAlertTitle:(NSString *)title
                    content:(NSString *)content {
    
}

+ (LRAlert *)showAlertTitle:(NSString *)title
                    content:(NSString *)content
                 actionText:(NSString *)text {
    
}

+ (LRAlert *)showAlertTitle:(NSString *)title
                    content:(NSString *)content
                actionLabel:(UILabel *)label
                   callback:(LRCallback)callback {
    
    LRAlert *alert = [[LRAlert alloc] init];
    
    LEEBaseConfigModel *config = [LEEAlert alert].config;
    
    alert.config = config;
    
    config.LeeBackgroundStyleTranslucent(LRAlertBackgroundOpciaty);
    
    if(title && title.length > 0) config.LeeTitle(title);
    if(content && content.length > 0) config.LeeContent(content);
    
    if(!label) {
        label = [self knownLabel];
    }
    label.textAlignment = NSTextAlignmentCenter;
    
    config.LeeAddAction(^(LEEAction * _Nonnull action) {
        if (label.attributedText) {
            action.attributedTitle = label.attributedText;
        }else {
            action.title = label.text;
            action.font = label.font;
            action.titleColor = label.textColor;
            action.textAlignment = label.textAlignment;
        }
        action.clickBlock = callback;
    });

    config.LeeShow();
    
    return alert;
}

+ (LRAlert *)showAlertTitle:(NSString *)title
                    content:(NSString *)content
            leftActionLabel:(UILabel *)leftLabel
               leftCallback:(LRCallback)leftCallback
            leftActionLabel:(UILabel *)rightLabel
              rightCallback:(LRCallback)rightCallback {
    
    LRAlert *alert = [[LRAlert alloc] init];
    
    LEEBaseConfigModel *config = [LEEAlert alert].config;
    
    alert.config = config;
    
    config.LeeBackgroundStyleTranslucent(LRAlertBackgroundOpciaty);
    
    if(title && title.length > 0) config.LeeTitle(title);
    if(content && content.length > 0) config.LeeContent(content);
    
    if(!leftLabel) {
        leftLabel = [self cancelLabel];
    }
    leftLabel.textAlignment = NSTextAlignmentCenter;
    
    config.LeeAddAction(^(LEEAction * _Nonnull action) {
        if (leftLabel.attributedText) {
            action.attributedTitle = leftLabel.attributedText;
        }else {
            action.title = leftLabel.text;
            action.font = leftLabel.font;
            action.titleColor = leftLabel.textColor;
            action.textAlignment = leftLabel.textAlignment;
        }
        action.clickBlock = leftCallback;
    });

    if(!rightLabel) {
        rightLabel = [self confirmLabel];
    }
    leftLabel.textAlignment = NSTextAlignmentCenter;
    
    config.LeeAddAction(^(LEEAction * _Nonnull action) {
        if (rightLabel.attributedText) {
            action.attributedTitle = rightLabel.attributedText;
        }else {
            action.title = rightLabel.text;
            action.font = rightLabel.font;
            action.titleColor = rightLabel.textColor;
            action.textAlignment = rightLabel.textAlignment;
        }
        action.clickBlock = rightCallback;
    });

    
    config.LeeShow();
    
    return alert;
    
}

+ (LRAlert *)showCustomAlert:(UIView *)customView {
    
    LRAlert *alert = [[LRAlert alloc] init];
    
    LEEBaseConfigModel *config = [LEEAlert alert].config;
    
    config.LeeCustomView(customView).leeShouldClose(^BOOL{
        return NO;
    }).LeeShow();
    
    alert.config = config;
    
    return alert;
}

- (LRAlert *)backgroundOpacity:(double)opacity {
    self.config.LeeBackgroundStyleTranslucent(LRAlertBackgroundOpciaty);
    self.config.LeeShow();
    return self;
}

// 默认自动为自动隐藏，个别不要自动隐藏的配置后需手动隐藏
- (LRAlert *)autoHidden:(BOOL)hidden {
    return self;
}

- (void)hidden {
    self.config.LeeCloseComplete(^{});
}

#pragma mark - Private

+ (UILabel *)labelText:(NSString *)text color:(UIColor *)color font:(UIFont *)font align:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    return label;
}

+ (UILabel *)actionLabel:(NSString *)text color:(UIColor *)color {
    return [self labelText:text color:color font:[UIFont systemFontOfSize:16] align:NSTextAlignmentCenter];
}

+ (UILabel *)confirmLabel {
    return [self actionLabel:LRActionTextConfirm color:[UIColor systemBlueColor]];
}

+ (UILabel *)cancelLabel {
    return [self actionLabel:LRActionTextCancel color:[UIColor grayColor]];
}

+ (UILabel *)knownLabel {
    return [self actionLabel:LRActionTextKnown color:[UIColor systemBlueColor]];
}

@end
