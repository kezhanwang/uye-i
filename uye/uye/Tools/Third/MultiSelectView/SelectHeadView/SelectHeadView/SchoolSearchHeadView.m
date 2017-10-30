//
//  SchoolSearchHeadView.m
//  MultiSelectView
//
//  Created by Tintin on 2017/3/31.
//  Copyright © 2017年 Tintin. All rights reserved.
//


#import "SchoolSearchHeadView.h"
#import "KZTextField.h"
typedef void(^MakeSureSchoolBlock)(NSString * schoolName);

@interface SchoolSearchHeadView ()
@property (nonatomic, strong) UIButton * searchBtn;
@property (nonatomic, strong) UIButton * makeSureBtn;
@property (nonatomic, strong) KZTextField * searchTextF;
@property (nonatomic, copy) MakeSureSchoolBlock makeBlock;
@end
#ifndef kScreenWidth
#define kScreenWidth    CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

#ifndef kScreenHeight
#define kScreenHeight    CGRectGetHeight([UIScreen mainScreen].bounds)
#endif

#define SchoolSearchHeadViewHeight 44

@implementation SchoolSearchHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchBtn];
        [self addSubview:self.searchTextF];
        [self addSubview:self.makeSureBtn];
        [self setContentSize:CGSizeMake(kScreenWidth*2, SchoolSearchHeadViewHeight)];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollEnabled = NO;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)textFieldTextDidChanged {
    if (self.searchTextF.text.length >0) {
        [self.makeSureBtn setEnabled:YES];
    }else{
        [self.makeSureBtn setEnabled:NO];
    }
}
- (void)makeSureButtonAction:(void (^)(NSString *))block {
    self.makeBlock = block;
}

- (void)showSearchTextField {
    [self setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}
- (void)makeSureschoolName {
    if (self.searchTextF.text.length != 0) {
        if (self.makeBlock) {
            self.makeBlock(self.searchTextF.text);
        }
    }
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(0, 0, kScreenWidth, SchoolSearchHeadViewHeight);
        [_searchBtn setTitle:@"找不到？" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchBtn addTarget:self action:@selector(showSearchTextField) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
- (UITextField *)searchTextF {
    if (!_searchTextF) {
        _searchTextF = [[KZTextField alloc]initWithFrame:CGRectMake(kScreenWidth+15, 6, kScreenWidth - 80,SchoolSearchHeadViewHeight-12)];
        _searchTextF.placeholder = @"没找到您所在的院校？请手动填写";
        _searchTextF.layer.borderWidth = 1.f;
        _searchTextF.font = [UIFont systemFontOfSize:15];
       
        [_searchTextF setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
        _searchTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _searchTextF.layer.borderColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1].CGColor;
        _searchTextF.layer.cornerRadius = 2.f;
        _searchTextF.layer.masksToBounds = YES;
    }
    return _searchTextF;
}
- (UIButton *)makeSureBtn {
    if (!_makeSureBtn) {
        _makeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeSureBtn.frame = CGRectMake(kScreenWidth*2 - 65, 0, 60, SchoolSearchHeadViewHeight);
        [_makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_makeSureBtn setEnabled:NO];
        [_makeSureBtn setTitleColor:[UIColor colorWithRed:166.0/255 green:166.0/255 blue:166.0/255 alpha:1] forState:UIControlStateDisabled];
        [_makeSureBtn addTarget:self action:@selector(makeSureschoolName) forControlEvents:UIControlEventTouchUpInside];
        [_makeSureBtn setTitleColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] forState:UIControlStateNormal];
        _makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    }
    return _makeSureBtn;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
