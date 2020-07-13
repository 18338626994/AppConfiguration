//
//  LRRespModel.h
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/6/5.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "LRNetStatus.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LRResqType){
    post,         //post请求
    post_formData,//post表单请求
    post_body,    //post body请求
    get,          //get请求
    put,          //put请求
    put_body,     //put body请求
    delete,       //delete请求
};

@interface LRRespModel : NSObject

// 成功
@property (nonatomic, assign) BOOL success;
// 请求
@property (nonatomic, strong) NSURLSessionDataTask *task;
// Error信息
@property (nonatomic, strong) NSError *error;

// 原始返回结果
@property (nonatomic, copy) id result;
// 将返回结果处理成的对象
@property (nonatomic, strong) id responseObject;

@end


@interface LRResqModel : NSObject

@property (nonatomic,assign,readwrite) LRResqType reqType;//请求类型
@property (nonatomic,assign,readwrite) LRNetState netState;//请求网络状态
@property (nonatomic, copy, readwrite) NSString *path;//最终请求路径
@property (nonatomic, copy, readwrite) NSDictionary *params;//最终请求参数

@property (nonatomic, copy, readwrite) NSString *body;

@property (nonatomic, copy) void (^FormData)(id<AFMultipartFormData> formData);
@property (nonatomic, copy) void (^UploadProgress)(NSProgress *uploadProgress);


- (void)addParams:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
