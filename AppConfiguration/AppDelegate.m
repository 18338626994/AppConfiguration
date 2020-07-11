//
//  AppDelegate.m
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/6/29.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "AppDelegate.h"
#import "LEEAlert.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *log = @"";
    
#if (APP_CONFIG_FLAG == 0)
    log = @"生产环境";
#elif (APP_CONFIG_FLAG == 1)
    log = @"Debug环境";
#elif (APP_CONFIG_FLAG == 2)
    log = @"测试环境";
#endif
    
    NSLog(@"当前运行环境：%@",log);
    
    _engine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
    [_engine runWithEntrypoint:nil];
    
    [GeneratedPluginRegistrant registerWithRegistry:_engine];
    
    [LEEAlert configMainWindow:self.window];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
