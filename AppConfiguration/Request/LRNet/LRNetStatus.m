//
//  LRNetState.m
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/6/5.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "LRNetStatus.h"
#import <UIKit/UIKit.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "AFNetworkReachabilityManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NSString * const kLRNetStateDidChangedNotification = @"kLRNetStateDidChangedNotification";

@interface LRNetStatus()
{
    LRNetState _status;
}

@property (nonatomic, assign) AFNetworkReachabilityStatus reachablityStatus;
@property (nonatomic, strong) CTTelephonyNetworkInfo *telephonyNetworkInfo;
@property (nonatomic, strong) NSString *currentRadioAccessTechnology;

@end

@implementation LRNetStatus

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    static LRNetStatus *_netStatus;
    dispatch_once(&onceToken, ^{
        _netStatus = [[LRNetStatus alloc] init];
    });
    return _netStatus;
}

- (id)copyWithZone:(NSZone*)zone{
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak __typeof(self) wself = self;
        _status = LRNetStateUnknown;
        _reachablityStatus = AFNetworkReachabilityStatusUnknown;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            wself.reachablityStatus = status;
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        self.telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetState) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetState) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)updateNetState {
    NSLog(@"update");
    if (self.reachablityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        _status = [self _WWANStatus];
    }
}

- (NSString *)currentRadioAccessTechnology{
    return self.telephonyNetworkInfo.currentRadioAccessTechnology;
}

- (NSString *)currentNetDesc {
    
    switch (_status) {
        case LRNetStateNone: return @"无网络";
        case LRNetState2G: return @"2G网络";
        case LRNetState3G: return @"3G网络";
        case LRNetState4G: return @"4G网络";
        case LRNetState5G: return @"5G网络";
        case LRNetStateWWAN: return @"蜂窝网络";
        case LRNetStateWifi: return @"WiFi网络";
        default: return @"未知";
    }
}

- (LRNetState)currentNetState {
    return _status;
}

- (BOOL)isNetworking {
    return _status != LRNetStateNone && _status != LRNetStateUnknown;
}

/*
 * 是否是弱网环境(2G为弱网)
 */
- (BOOL)isWeakNet {
    return _status == LRNetState2G;
}

/*
* 是否是强网环境(wifi、5G为强网)
*/
- (BOOL)isStrongNet {
    return _status == LRNetStateWifi || _status == LRNetState5G;
}

- (BOOL)isWifiNet {
    return _status == LRNetStateWifi;
}

//IP
- (NSString *)wifiIPAddress {
    return [self _ipWithType:@"en0"];
}

- (NSString *)WWANIPAddress {
    return [self _ipWithType:@"pdp_ip0"];
}

- (void)setReachablityStatus:(AFNetworkReachabilityStatus)reachablityStatus {
    
    if (reachablityStatus != _reachablityStatus) {
        LRNetState _oldStatus = _status;
        _reachablityStatus = reachablityStatus;
        switch (reachablityStatus) {
            case AFNetworkReachabilityStatusUnknown:
                _status = LRNetStateUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _status = LRNetStateNone;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status = [self _WWANStatus];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status = LRNetStateWifi;
                break;
            default:
                break;
        }
        if (_oldStatus != _status) {
            NSDictionary *userInfo = @{
                @"old": @(_oldStatus),
                @"new": @(_status)
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:kLRNetStateDidChangedNotification object:nil userInfo:userInfo];
        }
    }
}

#pragma mark - Private

- (NSString *)_ipWithType:(NSString *)type{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:type]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (LRNetState)_WWANStatus {
    
    if ([self.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        return LRNetState4G;
    }
    
    if ([@[CTRadioAccessTechnologyHSDPA,
          CTRadioAccessTechnologyWCDMA,
          CTRadioAccessTechnologyHSUPA,
          CTRadioAccessTechnologyCDMA1x,
          CTRadioAccessTechnologyCDMAEVDORev0,
          CTRadioAccessTechnologyCDMAEVDORevA,
          CTRadioAccessTechnologyCDMAEVDORevB,
          CTRadioAccessTechnologyeHRPD] containsObject:self.currentRadioAccessTechnology]) {
        return LRNetState3G;
    }
    
    if ([@[CTRadioAccessTechnologyEdge,CTRadioAccessTechnologyGPRS] containsObject:self.currentRadioAccessTechnology]) {
        return LRNetState2G;
    }
    
    if (!self.currentRadioAccessTechnology) {
        return [self _cuttentStatusBarDataNetworkTag];
    }
    
    return LRNetStateWWAN;
}

- (LRNetState)_cuttentStatusBarDataNetworkTag{
    
    NSArray *subviews = nil;
    id statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    if ([statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        subviews = [[[statusBar valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    } else {
        subviews = [[statusBar valueForKey:@"foregroundView"] subviews];
    }
    
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    LRNetState status = LRNetStateUnknown;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
        case 0:
            status = LRNetStateNone;
            break;
        case 1:
            status = LRNetState2G;
            break;
        case 2:
            status = LRNetState3G;
            break;
        case 3:
            status = LRNetState4G;
            break;
        case 4:
            status = LRNetState4G;
            break;
        case 5:
            status = LRNetStateWifi;
            break;
        default:
            break;
    }
    return status;
}


@end
