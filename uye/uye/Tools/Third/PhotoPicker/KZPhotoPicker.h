//
//  KZPhotoPicker.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPhotoPickerConfig.h"
@interface KZPhotoPicker : NSObject

@property(nonatomic, strong)KZPhotoPickerConfig * config;


/**
 请使用`initWithConfig:`方法

 @return nil
 */
- (instancetype)init __unavailable;
/**
 初始化的方法

 @param config pucker的适配器
 @return KZPhotoPicker；
 */
- (instancetype)initWithConfig:(KZPhotoPickerConfig*)config;
/**
 直接展示相册

 @param complete 选取之后的回调，image数组
 */
- (void)showPhotoPickerComplete:(void(^)(NSArray *photos,NSError * error,BOOL isCamera))complete;

/**
 直接调取相册

 @param complete 调取之后的回调
 */
- (void)showCameraComplete:(void(^)(NSArray *photos,NSError * error,BOOL isCamera))complete;
/**
 先展示相册和拍照选择的ActionSheet
 @param showTitle 是否显示标题（最多%d张）
 @param complete 请求回调
 */
- (void)showPhotoPickerActionSheetShowTitle:(BOOL)showTitle complete:(void(^)(NSArray *photos,NSError * error,BOOL isCamera))complete;

@end
