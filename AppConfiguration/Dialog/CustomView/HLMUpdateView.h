//
//  HLMUpdateView.h
//  HLMAgent
//
//  Created by 汇来米-iOS于云飞 on 2019/9/26.
//  Copyright © 2019 PnR Data Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLMUpdateView : UIView

/**
 *  方法描述：版本更新
 *
 *  @param title    标题
 *  @param message  更新内容
 *  @param update   强制更新？
 *  @param confirm  确认更新回调
 *  @param cancel   取消回调
 *
 *  return HLMUpdateView
 *
 */
- (HLMUpdateView *)initWithTitle:(NSString *)title
                         version:(NSString *)version
                         message:(NSString *)message
                     forceUpdate:(BOOL)update
                         confirm:(void(^)(void))confirm
                          cancel:(void(^)(void))cancel;

+ (void)testUpdate;

@end

NS_ASSUME_NONNULL_END
