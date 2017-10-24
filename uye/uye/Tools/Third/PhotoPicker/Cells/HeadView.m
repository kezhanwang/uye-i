//
//  HeadView.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "HeadView.h"
typedef void (^BackButtonHandler)(void);
typedef BOOL (^SelectButtonHandler)(void);
@interface HeadView ()
@property (nonatomic,strong)UIButton * backButton;
@property (nonatomic,strong)UIButton * selectButton;
@property (nonatomic,copy)BackButtonHandler backHandler;
@property (nonatomic,copy)SelectButtonHandler selectHandler;
@property (nonatomic,strong)UILabel * titleLabel;
@end

@implementation HeadView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor =[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(0, 0, screenSize.width, 64);
        [self addSubview:self.titleLabel];
        [self addSubview:self.backButton];
        [self addSubview:self.selectButton];
        
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = [title copy];
    [self.titleLabel setText:_title];
}
- (void)backAction {
    if (self.backHandler) {
        self.backHandler();
    }
}
- (void)selectImageAssetAction:(UIButton *)button {
    BOOL canSelect = self.selectHandler();
    [self.selectButton setSelected:canSelect];
}
- (void)backButtonClick:(void (^)(void))complete {
    self.backHandler = complete;
}
- (void)selectButtonAction:(BOOL (^)(void))complete {
    if (complete) {
        self.selectHandler = complete;
    }
}
- (void)updateSelectButtonStatus:(BOOL)isSelect {
    [self.selectButton setSelected:isSelect];
}
- (void)showHeaderView {
    [UIView animateWithDuration:0.3 animations:^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(0, 0, screenSize.width, 64);
    }];
}
- (void)hiddenHeaderView {
    [UIView animateWithDuration:0.3 animations:^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(0, -64, screenSize.width, 64);
    }];
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame =CGRectMake(0, 20, 50, 44);
        [_backButton setImage:[UIImage imageNamed:@"photo_picker_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIButton *)selectButton {
    if (!_selectButton) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _selectButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(screenSize.width-50, 20, 50, 44);
        [_selectButton setImage:[UIImage imageNamed:@"photo_picker_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"photo_picker_select"] forState:UIControlStateSelected];//选中状态icon
        [_selectButton addTarget:self action:@selector(selectImageAssetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, screenSize.width, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
@end
