//
//  LRNetStatus
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/6/5.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LRNetState){
    LRNetStateUnknown = 0,
    LRNetStateNone,
    LRNetState2G,
    LRNetState3G,
    LRNetState4G,
    LRNetState5G,
    LRNetStateWWAN,
    LRNetStateWifi,
};

// 用于网络状态变化发送通知
extern NSString *const kLRNetStateDidChangedNotification;

@interface LRNetStatus : NSObject

+ (id)sharedInstance;

- (NSString *)currentNetDesc;
- (LRNetState)currentNetState;

- (BOOL)isNetworking;

/*
 * 是否是弱网环境(2G为弱网)
 */
- (BOOL)isWeakNet;

/*
* 是否是强网环境(wifi、5G为强网)
*/
- (BOOL)isStrongNet;

- (BOOL)isWifiNet;

//IP
- (NSString *)wifiIPAddress;
- (NSString *)WWANIPAddress;

@end

NS_ASSUME_NONNULL_END
