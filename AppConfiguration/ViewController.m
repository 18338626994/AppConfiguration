//
//  ViewController.m
//  AppConfiguration
//
//  Created by 汇来米-iOS于云飞 on 2020/6/29.
//  Copyright © 2020 PnR. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"
#import "AppDelegate.h"
#import "HLMUpdateView.h"
#import "LRDialog.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)flutterDemoButtonClicked:(id)sender {
    FlutterEngine *engine = ((AppDelegate *)([UIApplication sharedApplication].delegate)).engine;
    if (engine) {
        FlutterViewController *flutterVC = [[FlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
        [self presentViewController:flutterVC animated:YES completion:nil];
    }
}

- (IBAction)alertButtonClicked:(id)sender {
    
    //[self testCustomAlert1];
    
    [self testAlertClickNotClose];
    
}

- (IBAction)toastButtonClicked:(id)sender {
    [LRDialog showToast:@"刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种" duration:2];
}

- (IBAction)loadingButtonClicked:(UIButton *)sender {
    [LRDialog showLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LRDialog dismissLoading];
    });
}

- (IBAction)dismissButtonClicked:(UIButton *)sender {
    [LRDialog dismissLoading];
}

- (IBAction)actionSheetButtonClicked:(id)sender {
    NSArray <LRActionConfig>* actionConfigs = @[
        ^(LEEAction *action) {
            action.title = @"哎吆，我去";
            action.titleColor = [UIColor systemRedColor];
        },
        ^(LEEAction *action) {
            action.title = @"牛逼了";
            action.titleColor = [UIColor blueColor];
        },
        ^(LEEAction *action) {
             action.title = @"响应国家号召";
             action.titleColor = [UIColor greenColor];
         },
    ];
    [LRDialog showSheetTitle:@"《关于未成年人网吧规范》" content:@"根据国家第2020号文件规定：未成年人网吧最小上网年龄更新至16岁" actionConfigs:actionConfigs cancelConfig:^(LEEAction *action) {
        action.title = @"知道了";
    }];
}

#pragma mark - Test

- (void)testAlert {
    [LRDialog showAlertTitle:@"霸道网吧" content:@"刘二狗子你妈喊你回家吃饭，不吃不行的那种..."];
}

- (void)testAlertClickNotClose {
    [LRDialog showAlertTitle:@"霸道网吧" content:@"刘二狗子你妈喊你回家吃饭，不吃不行的那种..." leftConfig:^(LEEAction *action) {
        
        action.title = @"滚";
        action.titleColor = [UIColor systemRedColor];
        action.isClickNotClose = YES;
        action.clickBlock = ^{
            
            NSLog(@"瓜娃子，不走不行的...");
            
            [LRDialog showToast:@"刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种,刘二狗子你妈喊你回家吃饭，不吃不行的那种"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LRDialog dismissAlert];
            });
        };
    } rightConfig:^(LEEAction *action) {
        action.title = @"立刻回家";
        action.titleColor = [UIColor systemBlueColor];
    }];
}

- (void)testCustomAlert1 {
    
    NSString *message = @"1.更新了太多人吐槽的页面.\n2.删除了没什么用的福利一览.\n3.整体代码精简，从原来的50M精简到现在的25M.";
    
    HLMUpdateView *customView = [[HLMUpdateView alloc] initWithTitle:@"更新内容" version:@"1.0.1" message:message forceUpdate:NO confirm:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1389755424"]];
    } cancel:^{
        [LRDialog dismissAlert];
    }];
    [LRDialog showCustomAlert:customView opacity:0.4];
    
}

@end
