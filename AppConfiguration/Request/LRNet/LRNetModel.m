//
//  LRRespModel.m
//  YYFKit
//
//  Created by 汇来米-iOS于云飞 on 2020/6/5.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "LRNetModel.h"

@implementation LRRespModel

@end

@implementation LRResqModel

- (void)addParams:(NSDictionary *)params{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [dic addEntriesFromDictionary:params];
    self.params = [dic copy];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"\npath:%@\nparams:%@\nstatus:%@",self.path,self.params,@(self.netState)];
}

@end


