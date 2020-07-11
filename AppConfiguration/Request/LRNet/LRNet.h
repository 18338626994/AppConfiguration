//
//  LRNet.h
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/6/5.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LRNetModel.h"
#import "LRNetConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRNet : NSObject<LRNetConfig>

@property (nonatomic, strong, readwrite) LRRespModel *response;
@property (nonatomic, strong, readwrite) LRResqModel *request;

@property (nonatomic, strong, readwrite) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong, readwrite) NSURLSessionDataTask *dataTask;//当发起请求后有值

/**
 *  设置超时时间
 */
- (id)resetTimeout:(NSTimeInterval)timeInterval;

/**
 *  设置回调
 */
- (id)setResqDelegate:(id<LRResqDelegate>)delegate;

#pragma mark - 请求提醒配置
/**
 *  配置定制 NetTipsConfig
 */
- (id)resetLoadConfig:(id<LRLoadDelegate>)tipsConfig;

/**
 *  配置加载过程
 */
- (id)setLoadMode:(LRLoadOption)mode;

/**
 *  配置请求参数
 */
- (id)configRequest:(LRResqModel *)request;

#pragma mark - 发起请求
/**
 *  配置callback 发送请求
 */
- (id)requestCallBack:(void (^)(LRRespModel *LRRespModel))callBack;

/**
 *  重新发起请求
 */
- (id)reRequest;

/**
 *  发起请求
 */
- (id)requestOnly;


@end

NS_ASSUME_NONNULL_END
