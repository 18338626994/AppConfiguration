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
#import "LRAlert.h"

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
    
    [self testCustomAlert1];
}

- (IBAction)toastButtonClicked:(id)sender {
    
}

- (IBAction)loadingButtonClicked:(id)sender {
    
}

- (IBAction)actionSheetButtonClicked:(id)sender {
    
}

#pragma mark - Test

- (void)testAlert {
    [LRAlert showAlertTitle:@"霸道网吧" content:@"刘二狗子你妈喊你回家吃饭，不吃不行的那种..."];
}

- (void)testAlertClickNotClose {
    [LRAlert showAlertTitle:@"霸道网吧" content:@"刘二狗子你妈喊你回家吃饭，不吃不行的那种..." leftConfig:^(LEEAction *action) {
        
        action.title = @"滚";
        action.titleColor = [UIColor systemRedColor];
        action.isClickNotClose = YES;
        action.clickBlock = ^{
            NSLog(@"瓜娃子，不走不行的...");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LRAlert dismissAlert];
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
        [LRAlert dismissAlert];
    }];
    [LRAlert showCustomAlert:customView opacity:0.4];
    
}

@end
