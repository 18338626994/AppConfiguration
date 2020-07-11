//
//  LRNet.m
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/6/5.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "LRNet.h"
#import "LRNetStatus.h"

@interface LRNet ()

#pragma mark - 请求内容
@property (nonatomic, weak) id<LRResqDelegate> delegate;

#pragma mark - 请求提示
@property (nonatomic, weak) id<LRLoadDelegate> loadConfig;
@property (nonatomic, assign) BOOL needLoading;
@property (nonatomic, assign) BOOL needErrorTip;
@property (nonatomic, assign) BOOL needSuccessTip;
@property (nonatomic, assign) BOOL isQuiet;

#pragma mark - 请求时网络状态
@property (nonatomic, assign) LRNetState netState;

#pragma mark - requestCallback
@property (nonatomic, copy) void (^callback)(LRRespModel *model);


@end

@implementation LRNet

- (void)dealloc {
    _response = nil;
    _request = nil;
    _httpManager = nil;
    _dataTask = nil;
    _loadConfig = nil;
    _callback = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)resetTimeout:(NSTimeInterval)timeInterval {
    self.httpManager.requestSerializer.timeoutInterval = timeInterval;
    return self;
}

- (id)setResqDelegate:(id<LRResqDelegate>)delegate {
    self.delegate = delegate;
    return self;
}

- (id)resetLoadConfig:(id<LRLoadDelegate>)loadConfig{
    self.loadConfig = loadConfig;
    return self;
}

- (id)setLoadMode:(LRLoadOption)mode{
    self.needLoading = (mode & LRLoadOptionShowLoading) == LRLoadOptionShowLoading;
    self.needErrorTip = (mode & LRLoadOptionShowErrorTips) == LRLoadOptionShowErrorTips;
    self.needSuccessTip = (mode & LRLoadOptionShowSuccessTips) == LRLoadOptionShowSuccessTips;
    self.isQuiet = (mode & LRLoadOptionNoStatusLoading) == LRLoadOptionNoStatusLoading;
    return self;
}

- (id)configRequest:(LRResqModel *)request{
    self.request = request;
    return self;
}


#pragma mark - 发起请求

- (void)preRequestHandle{
    
    if ([self respondsToSelector:@selector(handleRequestWithNetEngine:)]) {
        [self handleRequestWithNetEngine:self];
    }
}

- (id)request {
  
    if (!self.isQuiet) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    if (self.needLoading && [self.loadConfig respondsToSelector:@selector(showLoading)]) {
        [self.loadConfig showLoading];
    }
    
    self.netState = [[LRNetStatus sharedInstance] currentNetState];
    
    __weak typeof(self) wself = self;
    
    switch (self.request.reqType) {
        case get:
        {
            self.dataTask = [self.httpManager GET:self.request.path parameters:self.request.params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                __strong typeof(wself) sself = wself;
                [sself _handleSuccessResponseWithInfo:result];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(wself) sself = wself;
                [sself _handleFailureResponseWithError:error];
            }];
        }
            break;
        case post:
        {
            self.dataTask = [self.httpManager POST:self.request.path parameters:self.request.params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                __strong typeof(wself) sself = wself;
                [sself _handleSuccessResponseWithInfo:result];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(wself) sself = wself;
                [sself _handleFailureResponseWithError:error];
            }];
        }
            break;
        case put:
        {
            self.dataTask = [self.httpManager PUT:self.request.path parameters:self.request.params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                __strong typeof(wself) sself = wself;
                [sself _handleSuccessResponseWithInfo:result];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(wself) sself = wself;
                [sself _handleFailureResponseWithError:error];
            }];
        }
            break;
        case delete:
        {
            self.dataTask = [self.httpManager DELETE:self.request.path parameters:self.request.params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                __strong typeof(wself) sself = wself;
                [sself _handleSuccessResponseWithInfo:result];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(wself) sself = wself;
                [sself _handleFailureResponseWithError:error];
            }];
        }
            break;
        case post_formData:
        {
            
            self.dataTask = [self.httpManager POST:self.request.path parameters:self.request.params headers:nil constructingBodyWithBlock:self.request.FormData progress:self.request.UploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                __strong typeof(wself) sself = wself;
                [sself _handleSuccessResponseWithInfo:result];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong typeof(wself) sself = wself;
                [sself _handleFailureResponseWithError:error];
            }];
        }
            break;
        case post_body:
        {
            NSMutableURLRequest *request = [self.httpManager.requestSerializer requestWithMethod:@"POST" URLString:self.request.path parameters:self.request.params error:nil];
            [request setHTTPBody:[self.request.body dataUsingEncoding:NSUTF8StringEncoding]];
            
            self.dataTask = [self.httpManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
                __strong typeof(wself) sself = wself;
                if (result) {
                    [sself _handleSuccessResponseWithInfo:result];
                }else{
                    [sself _handleFailureResponseWithError:error];
                }
            }];
            
            [self.dataTask resume];
        }
            break;
        case put_body:
        {
            NSMutableURLRequest *request = [self.httpManager.requestSerializer requestWithMethod:@"PUT" URLString:self.request.path parameters:self.request.params error:nil];
            [request setHTTPBody:[self.request.body dataUsingEncoding:NSUTF8StringEncoding]];
            
            self.dataTask = [self.httpManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
                __strong typeof(wself) sself = wself;
                if (result) {
                    [sself _handleSuccessResponseWithInfo:result];
                }else{
                    [sself _handleFailureResponseWithError:error];
                }
            }];
            [self.dataTask resume];
        }
            break;
        default:
        {
            self.dataTask = nil;
            if (self.needLoading && [self.loadConfig respondsToSelector:@selector(dismissLoading)]) [self.loadConfig dismissLoading];
            if (!self.isQuiet) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
            break;
    }
    
    return self;
}

- (id)requestCallBack:(void (^)(LRRespModel *))requestCallback{
    self.callback = requestCallback;
    [self preRequestHandle];
    [self request];
    
    return self;
}

- (id)requestOnly{
    return [self request];
}

- (id)reRequest{
    return [self request];
}

- (void)_handleSuccessResponseWithInfo:(id)result{
    // 如果配置了加载loadding框，则取消loading
    if (self.needLoading && [self.loadConfig respondsToSelector:@selector(dismissLoading)]) {
        [self.loadConfig dismissLoading];
    }
    // 静默请求，隐藏状态栏loading
    if (!self.isQuiet) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    LRRespModel *model = [[LRRespModel alloc] init];
    model.task = self.dataTask;
    model.result = result;
    self.response = model;
    
    [self handleResponseWithNetEngine:self];
    
    if ([self.delegate respondsToSelector:@selector(requestDidSuccessWithNetEngine:)]) {
        [self.delegate requestDidSuccessWithNetEngine:self];
    }
    
    if (self.callback) {
        self.callback(self.response);
    }
    
    if ([self.loadConfig respondsToSelector:@selector(showTipsWithNetEngine:)]) {
        if ((self.response.success && self.needSuccessTip) || (!self.response.success && self.needErrorTip)) {
            [self.loadConfig showTipsWithNetEngine:self];
        }
    }
    
}

- (void)_handleFailureResponseWithError:(NSError *)error{
    
    if (self.needLoading && [self.loadConfig respondsToSelector:@selector(dismissLoading)]) [self.loadConfig dismissLoading];
    if (!self.isQuiet) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    LRRespModel *model = [[LRRespModel alloc] init];
    model.task = self.dataTask;
    model.error = error;
    self.response = model;
    
    [self handleResponseWithNetEngine:self];
    
    if ([self.delegate respondsToSelector:@selector(requestDidFailureWithNetEngine:)]) {
        [self.delegate requestDidFailureWithNetEngine:self];
    }
    
    if (self.callback) {
        self.callback(self.response);
    }
    
    if ([self.loadConfig respondsToSelector:@selector(showTipsWithNetEngine:)]) {
        if (!self.response.success && self.needErrorTip) {
            [self.loadConfig showTipsWithNetEngine:self];
        }
    }
    
}

- (void)handleResponseWithNetEngine:(id)engine{}


#pragma mark - setter getter
- (AFHTTPSessionManager *)httpManager {
    if (!_httpManager) {
        _httpManager = [[AFHTTPSessionManager alloc] init];
        _httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        _httpManager.requestSerializer.timeoutInterval = 15;
    }
    return _httpManager;
}

@end
