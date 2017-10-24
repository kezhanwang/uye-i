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
        self.barButtonColor = [UIColor colorWithRed:0 green:165.0/255 blue:240.0/255 alpha:1];
        self.navigationBarColor = [UIColor colorWithRed:0 green:165.0/255 blue:240.0/255 alpha:1];
        self.navigationTitleColor = [UIColor whiteColor];
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
