//
//  HLMLoadConfig.m
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/12.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "HLMLoadConfig.h"
#import "HLMNet.h"
#import "LRDialog.h"
#import "HLMResponse.h"

@interface HLMLoadConfig ()

@property (nonatomic, copy) NSString *unvalidLoginStatus;

@end

@implementation HLMLoadConfig

static HLMLoadConfig *_loadConfig;

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loadConfig = [[HLMLoadConfig alloc] init];
        _loadConfig.unvalidLoginStatus = @"90110-90111-90112-90113-90124";
    });
    return _loadConfig;
}

#pragma LRLoadDelegate

- (void)showLoading {
    [LRDialog showLoading];
}

- (void)dismissLoading {
    [LRDialog dismissLoading];
}

- (void)showTipsWithNetEngine:(HLMNet *)engine {
    
    NSString *unvalidStatus = _loadConfig.unvalidLoginStatus;
    HLMResponse *reponse = engine.response.responseObject;
    
    if ([unvalidStatus containsString:reponse.respCode]) {
        // 无效登录态，提示框
        if (![LEEAlert containsQueueWithIdentifier:@"loginInvalid"]) {
            [LEEAlert alert].config
            .LeeTitle(@"登录超时")
            .LeeContent(@"登录已超时，请重新登录！")
            .LeeAction(@"确认",^{
                // 去登录页
                NSLog(@"去登录页");
            })
            .LeeIdentifier(@"loginInvalid")
            .LeeQueue(YES) // 添加到队列
            .LeeShow();
        }
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LRDialog showToast:reponse.respDesc duration:2];
        });
    }
}


@end
