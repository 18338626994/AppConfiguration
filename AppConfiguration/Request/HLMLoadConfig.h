//
//  HLMLoadConfig.h
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/12.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRNetConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLMLoadConfig : NSObject<LRLoadDelegate>

+ (id)sharedInstance;

@end

NS_ASSUME_NONNULL_END
