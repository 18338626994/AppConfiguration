//
//  LRLoading.h
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRLoading : NSObject


/*
 * 可以配置Loading、Toast、Alert的background透明度
 * 默认为：
 *  Loading: 0.4
 *  Toast:   0.6
 *  Alert:   0.0
 *  Sheet:   0.0
 *
 */
- (LRLoading *)backgroundOpacity:(double)opacity;

@end

