//
//  LRNetConfig.h
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/6/6.
//  Copyright © 2020 PnR. All rights reserved.
//

#ifndef LRNetConfig_h
#define LRNetConfig_h

typedef NS_ENUM(NSInteger, LRLoadOption){
    LRLoadOptionNone            = 0,       //默认显示状态栏加载
    LRLoadOptionShowLoading     = 1 << 0,  //显示加载动画
    LRLoadOptionShowErrorTips   = 1 << 1,  //显示错误提示
    LRLoadOptionShowSuccessTips = 1 << 2,  //显示成功提示
    LRLoadOptionNoStatusLoading = 1 << 3   //不显示状态栏加载
};

@protocol LRNetConfig <NSObject>

/**
 *  返回数据处理，比如返回数据加密了，需要解密后再赋值
 */
- (void)handleResponseWithNetEngine:(id)engine;

@optional
/**
 *  请求数据处理
 */
- (void)handleRequestWithNetEngine:(id)engine;

@end

@protocol LRLoadDelegate <NSObject>

/**
 *  加载动画显示，没实现的话就没有任何提示
 */
- (void)showLoading;

/**
 *  加载动画消失，没实现的话就没有任何提示
 */
- (void)dismissLoading;

/**
 *  显示提示信息，没实现的话就没有任何提示
 */
- (void)showTipsWithNetEngine:(id)engine;


@end

@protocol LRResqDelegate <NSObject>

@optional

/**
 *  请求成功时调用
 */
- (void)requestDidSuccessWithNetEngine:(id)engine;

/**
 *  请求失败时调用
 */
- (void)requestDidFailureWithNetEngine:(id)engine;


@end

#endif /* LRNetConfig_h */
