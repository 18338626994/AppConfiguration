//
//  HLMNet.h
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/7/9.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "LRNet.h"
#import "HLMResponse.h"

#define __HLMNET [[HLMNet alloc] init]

@interface HLMNet : LRNet

/*
 * 全局默认配置
 *  可以配置默认LRLoadDelegate、LRResqDelegate、timeout等
 */
+ (void)defaultConfig:(void (^)(HLMNet *request))config;

/*
 * GET请求
 */
- (id)getPath:(NSString *)urlPath params:(NSDictionary *)params;

/*
 * POST请求
 */
- (id)postPath:(NSString *)urlPath params:(NSDictionary *)params;

/*
 * 图片上传
 */
- (id)uploadImagePath:(NSString *)urlPath imageData:(NSData *)data fileName:(NSString *)fileName;
/*
 * 文件上传
 */
- (id)uploadFilePath:(NSString *)urlPath fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end

