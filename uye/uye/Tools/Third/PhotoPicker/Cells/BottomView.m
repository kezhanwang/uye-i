//
//  BottomView.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

typedef void(^MakeSureButtonHadnler)(void);
#import "BottomView.h"
@interface BottomView ()
@property (nonatomic,strong)UIButton * makeSureBtn;
@property (nonatomic,copy)MakeSureButtonHadnler makeSureHandler;
@end
#import "UIImage+Reshape.h"
@implementation BottomView

- (instancetype)init {
    self =[super init];
    if (self) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(0, screenSize.height - 44, screenSize.width, 44);
        [self addSubview:self.makeSureBtn];
    }
    return self;
}
- (void)updateBottomStatusWithCount:(NSUInteger)count {
    NSString * title = [NSString stringWithFormat:@"完成(%lu)",(unsigned long)count];
    [self.makeSureBtn setTitle:title forState:UIControlStateNormal];
    if (count >0) {
        self.backgroundColor = [UIColor colorWithRed:162.0/255 green:209.0/255 blue:64.0/255 alpha:1.0];
        [self.makeSureBtn setEnabled:YES];
    }else{
        self.backgroundColor =[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self.makeSureBtn setEnabled:NO];
    }
}
- (void)setNormalBackColor:(UIColor *)normalBackColor {
    _normalBackColor = normalBackColor;
    if (_normalBackColor) {
        [_makeSureBtn setBackgroundImage:[[UIImage imageWithColor:_normalBackColor] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
    }
}
- (void)makeSureBtnAction:(UIButton *)button {
    if (self.makeSureHandler) {
        self.makeSureHandler();
    }
}
- (void)makeSureButtonClick:(void (^)(void))complete {
    self.makeSureHandler = complete;
}
- (void)showBottomView {
    [UIView animateWithDuration:0.3 animations:^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(0, screenSize.height - 44, screenSize.width, 44);
    }];
}
- (void)hiddenBottomView {
    [UIView animateWithDuration:0.3 animations:^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(0, screenSize.height, screenSize.width, 44);
    }];

}
- (UIButton *)makeSureBtn {
    if (!_makeSureBtn) {
        _makeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_makeSureBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
        [_makeSureBtn addTarget:self action:@selector(makeSureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _makeSureBtn.frame = self.bounds;
        [_makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_makeSureBtn setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateDisabled];
        [_makeSureBtn setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithRed:162.0/255 green:209.0/255 blue:64.0/255 alpha:1.0]] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];

    }
    return _makeSureBtn;
}
@end
