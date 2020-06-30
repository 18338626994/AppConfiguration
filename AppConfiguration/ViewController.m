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

@end
