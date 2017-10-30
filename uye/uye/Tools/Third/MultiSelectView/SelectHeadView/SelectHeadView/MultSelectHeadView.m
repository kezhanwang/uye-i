//
//  MultSelectHeadView.m
//  MultiSelectView
//
//  Created by Tintin on 2017/3/30.
//  Copyright © 2017年 Tintin. All rights reserved.
//
typedef void(^HeadViewCloseBlock)(void);
#import "MultSelectHeadView.h"
@interface MultSelectHeadView ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, copy) HeadViewCloseBlock closeBlock;
@end
#define MultSelectHeadViewHeight 44

@implementation MultSelectHeadView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self configViews];
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        self.frame = CGRectMake(0, 0, width, MultSelectHeadViewHeight);
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    self.closeButton.center = CGPointMake(CGRectGetWidth(self.bounds)-30, CGRectGetHeight(self.bounds)/2);
}
- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = _title;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}
-(void)closeButtonAction:(void (^)(void))action {
    self.closeBlock = action;
}
- (void)onCloseButtonAction {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(onCloseButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"loan_close_black"] forState:UIControlStateNormal];
        _closeButton.frame = CGRectMake(0, 0, 30, 30);
    }
    return _closeButton;
}
@end
