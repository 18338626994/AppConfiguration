//
//  HLMNet.m
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/7/9.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "HLMNet.h"

#define kSecuritySignSalt @"88888888"

@interface HLMNet()<LRResqDelegate>

@end

@implementation HLMNet

void (^_defaultConfig)(HLMNet *request);

+ (void)defaultConfig:(void (^)(HLMNet *request))config {
    _defaultConfig = config;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if(_defaultConfig) _defaultConfig(self);
        [self setResqDelegate:self];
    }
    return self;
}

- (NSString *)host {
    return @"";
}

#pragma mark - Request
- (id)getPath:(NSString *)urlPath params:(NSDictionary *)params {
    
    LRResqModel *model = [[LRResqModel alloc] init];
    model.path = [NSString stringWithFormat:@"%@%@",self.host, urlPath];
    model.params = params;
    model.reqType = get;
    self.request = model;
    
    return self;
}

- (id)postPath:(NSString *)urlPath params:(NSDictionary *)params {
    
    LRResqModel *model = [[LRResqModel alloc] init];
    model.path = [NSString stringWithFormat:@"%@%@",self.host, urlPath];
    model.params = params;
    model.reqType = post;
    self.request = model;
    
    return self;
}

- (id)uploadImagePath:(NSString *)urlPath
            imageData:(NSData *)data
             fileName:(NSString *)fileName {
    
    LRResqModel *model = [[LRResqModel alloc] init];
    model.path = [NSString stringWithFormat:@"%@%@",self.host, urlPath];
    model.FormData = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    };
    model.reqType = post_formData;
    self.request = model;
    
    return self;
}

- (id)uploadFilePath:(NSString *)urlPath
            fileData:(NSData *)data
            fileName:(NSString *)fileName
            mimeType:(NSString *)mimeType {
    
    LRResqModel *model = [[LRResqModel alloc] init];
    model.path = [NSString stringWithFormat:@"%@%@",self.host, urlPath];
    model.FormData = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
    };
    model.reqType = post_formData;
    self.request = model;
    
    return self;
}

#pragma mark - LRResqDelegate

- (void)requestDidSuccessWithNetEngine:(HLMNet *)engine {
    
    NSDictionary *result = engine.response.result;
    
    NSString *respSeq = [result objectForKey:@"respSeq"];
    NSString *respDesc = [result objectForKey:@"respDesc"];
    NSString *respCode = [result objectForKey:@"respCode"];
    NSString *respData = [result objectForKey:@"respData"];
    NSString *serverTime = [result objectForKey:@"serverTime"];
    NSString *requestSeqId = [result objectForKey:@"requestSeqId"];
    
    BOOL success = ([respCode intValue] == 90000);
    
    HLMResponse *responseObj = [[HLMResponse alloc] init];
    responseObj.success = success;
    responseObj.respSeq = respSeq;
    responseObj.respDesc = respDesc;
    responseObj.respCode = respCode;
    responseObj.respData = respData;
    responseObj.serverTime = serverTime;
    responseObj.requestSeqId = requestSeqId;
    
    engine.response.success = success;
    engine.response.responseObject = responseObj;
    
    // 90110|90111|90112|90113|90124  登录失效
}

- (void)requestDidFailureWithNetEngine:(HLMNet *)engine {
    NSError *error = engine.response.error;
    
    BOOL success = NO;
    NSString *respCode = [NSString stringWithFormat:@"%zd", error.code];
    NSString *respDesc = @"";
    
    HLMResponse *responseObj = [[HLMResponse alloc] init];
    responseObj.success = success;
    responseObj.respCode = respCode;
    responseObj.respDesc = respDesc;
    
    engine.response.success = success;
    engine.response.responseObject = responseObj;
    
}

#pragma mark - LRNetConfig

- (void)handleRequestWithNetEngine:(HLMNet *)engine {
    
    NSArray *types = @[
        @"application/json",
        @"text/html",
        @"text/json",
        @"text/plain",
        @"text/javascript",
        @"text/xml",
        @"image/*",
        @"application/octet-stream",
        @"application/pdf",
        @"application/zip"
    ];
    
    AFHTTPSessionManager *manager = engine.httpManager;
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:types];
    
    engine.request.params = [self _generateNewParams:engine];
    
}

- (void)handleResponseWithNetEngine:(HLMNet *)engine {
    
    if(engine.response.result) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:engine.response.result options:NSJSONReadingMutableContainers error:nil];
        engine.response.result = jsonObj;
    }
    
    // 如果必要可以再次解密返回数据...
    
    /*
    LRResqModel *model = engine.response;
    if (model.result) {
        NSDictionary *json;
        //是否需要解密
        
        if ([model.allHeaderFields[@"Content-Encrypt"] isEqualToString:@"AES/XHLM"]){
            NSString *encrypt = [[NSString alloc] initWithData:model.result encoding:NSUTF8StringEncoding];
            NSString *str = [encrypt decryptAES_NetWL];
            if (str) {
                json = [NSDictionary dictionaryWithJsonValue:str];
            }
        }else{
            json = [NSJSONSerialization JSONObjectWithData:model.result options:NSJSONReadingMutableContainers error:nil];
        }
        
        model.result = json;
    }
    */
}

#pragma mark - Private(参数及加密)
- (NSMutableDictionary *)_generateNewParams:(HLMNet *)engine {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:engine.request.params];

#warning 到工程中打开....
    
    /*
    // 系统参数
    NSString *_deviceNo = [HLMDeviceInfoUtil UUIDString];
    NSString *_ip = [HLMDeviceInfoUtil getIPAddress];
    if (EMPTY_STRING(_ip)) {
        _ip = [HLMDeviceInfoUtil getDeviceIPAdress];
    }
    NSString *_appVersion = [HLMDeviceInfoUtil appVersion];
    NSString *_appVer = [_appVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *_systermVersion = [HLMDeviceInfoUtil systemVersionStr];
    NSString *_deviceMode = [HLMDeviceInfoUtil getDeviceTypeName];
    NSString *_buildVersion = [HLMDeviceInfoUtil bundleVersion];
    NSString *_channel = @"AppStore";
    NSString *_appType = @"1";
    NSString *_platform = @"iOS";
    
    // 业务参数
    NSString *_sessionId = [HLMUserDefaultsUtil valueWithKey:kHLMSessionId];
    NSString *_userId = [HLMUserDefaultsUtil valueWithKey:kHLMUserId];
    NSString *_requestSeqId = [HLMDeviceInfoUtil randomUUIDdString];
    NSString *_pushId = [HLMUserDefaultsUtil valueWithKey:kHLMAliCloudPushDeviceId];
    NSString *_userCustIdGateWay = [HLMUserDefaultsUtil valueWithKey:kHLMUserCustId];
    
    [params addEntriesFromDictionary:@{
        @"ip" : GET_STRING(_ip),
        @"channel": GET_STRING(_channel),
        @"appType" : GET_STRING(_appType),
        @"platform" : GET_STRING(_platform),
        @"deviceNo" : GET_STRING(_deviceNo),
        @"appVer" : GET_STRING(_appVer),
        @"appVersion" : GET_STRING(_appVersion),
        @"buildVersion" : GET_STRING(_buildVersion),
        @"systermVersion" : GET_STRING(_systermVersion),
        @"deviceMode" : GET_STRING(_deviceMode),
        
        @"userId" : GET_STRING(_userId),
        @"pushId" : GET_STRING(_pushId),
        @"sessionId" : GET_STRING(_sessionId),
        @"requestSeqId" : GET_STRING(_requestSeqId),
        @"userCustIdGateWay" : GET_STRING(_userCustIdGateWay),
    }];
    */
    
    // 加入签名
    return [self _generateSignWithParams:params];
}

- (NSMutableDictionary *)_generateSignWithParams:(NSMutableDictionary *)params {
    
    NSArray *keySorted = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString * postParameterStr = @"";
    for (int i = 0; i < keySorted.count; i++) {
        
        NSString *key = [keySorted objectAtIndex:i];
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSArray class]] && [value count] >0) {
            NSString *arrParamStr = @"";
            for (int j = 0; j < [value count]; j++) {
                arrParamStr = [arrParamStr stringByAppendingFormat:@"%@,", [value objectAtIndex:j]];
            }
            [params setObject:[arrParamStr substringToIndex:arrParamStr.length - 1] forKey:key];
        }
        
        value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSString class]]) {
            value = [value stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
            value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
            value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
            value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
            value = [value stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
            value = [value stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
            value = [value stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
            value = [value stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
        }
        postParameterStr = [postParameterStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\",", key,value]] ;
    }
    
#warning 到工程中打开....
    
    /*
    NSString *jsonStr = [[@"{" stringByAppendingString:[postParameterStr substringToIndex:postParameterStr.length - 1]] stringByAppendingString:@"}"];
    
    NSString *signStr = [jsonStr stringByAppendingString:kSecuritySignSalt];
    NSString *encryptSignStr = [[signStr sha256Hash] lowercaseString];
    
    [params setValue:encryptSignStr forKey:@"sign"];
    */
    return params;
}

@end
