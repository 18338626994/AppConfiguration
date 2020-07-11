//
//  Header.h
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/7/10.
//  Copyright © 2020 PnR. All rights reserved.
//

#ifndef LRDialogHelper_h
#define LRDialogHelper_h

#import <UIKit/UIKit.h>

typedef void(^LRCallback)(void);

#define LRToastBackgroundOpciaty        0.6
#define LRAlertBackgroundOpciaty        0.0
#define LRLoaddingBackgroundOpciaty     0.4
#define LRActionSheetBackgroundOpciaty  0.0

#define LRActionTextConfirm @"确认"
#define LRActionTextCancel  @"取消"
#define LRActionTextKnown   @"知道了"

#define LRActionFont        [UIFont systemFontOfSize:16]
#define LRActionColorBlack  [UIColor blackColor]
#define LRActionColorBlue   [UIColor systemBlueColor]
#define LRActionColorRed    [UIColor systemRedColor]

#endif /* LRDialogHelper_h */
