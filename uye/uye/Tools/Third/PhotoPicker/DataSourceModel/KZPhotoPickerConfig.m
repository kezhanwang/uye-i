//
//  KZPhotoPickerConfig.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "KZPhotoPickerConfig.h"

@implementation KZPhotoPickerConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxNumberOfSelection = 9;
        self.allowsMultipleSelection = NO;
        self.isNeedEdit = NO;
        self.barButtonColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        self.navigationBarColor = [UIColor whiteColor];
        self.navigationTitleColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        self.reshapeScale = 4.0/3.0;
    }
    return self;
}
- (void)setIsNeedEdit:(BOOL)isNeedEdit {
    _isNeedEdit = isNeedEdit;
    if (_isNeedEdit) {
        self.allowsMultipleSelection = NO;
    }
}
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    if (_allowsMultipleSelection) {
        self.isNeedEdit = NO;
    }else{
        self.maxNumberOfSelection = 1;
    }
}
@end
