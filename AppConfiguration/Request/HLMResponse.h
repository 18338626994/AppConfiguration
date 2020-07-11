//
//  HLMResponse.h
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLMResponse : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, copy) NSString *requestSeqId;
@property (nonatomic, copy) NSString *respCode;
@property (nonatomic, copy) NSString *respSeq;
@property (nonatomic, copy) NSString *respDesc;
@property (nonatomic, copy) NSString *serverTime;

@property (nonatomic, copy) id respData;

@end

NS_ASSUME_NONNULL_END
