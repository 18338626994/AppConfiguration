//
//  AppManager.m
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/12.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "AppManager.h"
#import "HLMNet.h"
#import "HLMLoadConfig.h"

@implementation AppManager

+ (void)appNetConfig {
    [HLMNet defaultConfig:^(HLMNet *request) {
        [request resetTimeout:15];
        [request resetLoadConfig:[HLMLoadConfig sharedInstance]];
    }];
}

@end
