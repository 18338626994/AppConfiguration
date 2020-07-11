//
//  HLMUpdateView.m
//  HLMAgent
//
//  Created by 汇来米-iOS于云飞 on 2019/9/26.
//  Copyright © 2019 PnR Data Service Co.,Ltd. All rights reserved.
//

#import "HLMUpdateView.h"
#import "LEEAlert.h"

typedef void(^ActionCallback)(void);

@interface HLMUpdateView ()

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *version;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, assign) BOOL isForce;

@property (nonatomic, copy) ActionCallback confirm;
@property (nonatomic, copy) ActionCallback cancel;

@property (nonatomic, copy) NSDictionary *attributes;

@end

@implementation HLMUpdateView

- (HLMUpdateView *)initWithTitle:(NSString *)title
                         version:(NSString *)version
                         message:(NSString *)message
                     forceUpdate:(BOOL)update
                         confirm:(void(^)(void))confirm
                          cancel:(void(^)(void))cancel {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        _message = message;
        _version = version;
        _isForce = update;
        _confirm = confirm;
        _cancel = cancel;
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat selfWidth = 270;
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    contentView.layer.masksToBounds = YES;
    contentView.clipsToBounds = YES;
    
    [self addSubview:contentView];
    
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_update_top"]];
    topImageView.frame = CGRectMake(0, 0, 270, 130);
    [contentView addSubview:topImageView];
    
    UILabel *versionLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 63, 80, 22)];
    versionLab.font = [UIFont boldSystemFontOfSize:20];
    versionLab.text = _version;
    versionLab.textColor = [UIColor whiteColor];
    [topImageView addSubview:versionLab];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(topImageView.frame)+15, 100, 16)];
    titleLabel.text = _title;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    
    [contentView addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.numberOfLines = 0;
    messageLabel.attributedText = [self attributedContent];
    
    CGFloat messageWidth = selfWidth - (20*2);
    CGSize size = [_message boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes context:nil].size;
    messageLabel.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+10, messageWidth, size.height + 10);
    [contentView addSubview:messageLabel];
    
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updateButton.frame = CGRectMake(20, CGRectGetMaxY(messageLabel.frame)+20, messageWidth, 38);
    updateButton.backgroundColor = [UIColor systemRedColor];
    [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(updateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    updateButton.layer.cornerRadius = 4;
    updateButton.layer.masksToBounds = YES;
    [contentView addSubview:updateButton];
    
    contentView.frame = CGRectMake(0, 0, selfWidth, CGRectGetMaxY(updateButton.frame)+20);
    
    CGRect tempRect = contentView.frame;
    
    if (!_isForce) {
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake((selfWidth-50)/2, CGRectGetMaxY(contentView.frame)+12, 50, 50);
        [closeButton setImage:[UIImage imageNamed:@"icon_close_pop"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:closeButton];
        
        tempRect = closeButton.frame;
    }
    self.frame = CGRectMake(0, 0, 270, CGRectGetMaxY(tempRect)+12);
}

- (NSAttributedString *)attributedContent {
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:self.message attributes:[self attributes]];
    return atts;
}

- (NSDictionary *)attributes {
    if (_attributes == nil) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 6;
        _attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor grayColor],NSParagraphStyleAttributeName:style};
    }
    return _attributes;
}

#pragma mark - actions

- (void)closeButtonClicked:(UIButton *)sender {
    if (self.cancel) {
        self.cancel();
    }
}
- (void)updateButtonClicked:(UIButton *)sender {
    if (self.confirm) {
        self.confirm();
    }
}

+ (void)testUpdate {
    
    NSString *message = @"1.更新了太多人吐槽的页面.\n2.删除了没什么用的福利一览.\n3.整体代码精简，从原来的50M精简到现在的25M.";
    
    HLMUpdateView *customView = [[HLMUpdateView alloc] initWithTitle:@"更新内容" version:@"1.0.1" message:message forceUpdate:NO confirm:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1389755424"]];
    } cancel:^{
        [LEEAlert closeWithCompletionBlock:nil];
    }];
    
    [LEEAlert alert].config
    .LeeCustomView(customView)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow();
}

@end
