//
//  KZPhotoPickerConfig.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, KZPhotoPickerError){
    KZPhotoPickerSuccess = 0,
    KZPhotoPickerErrorUnknown = 1,
    KZPhotoPickerAlbumPermissions = 2,
    KZPhotoPickerCameraPermissions = 3,
    KZPhotoPickerPhotoReadFail = 4,//图片读取失败了。可能在系统压缩图片的时候block还没回调就直接返回了
    KZPhotoPickerUserCancel = 99,
    
};
#import <UIKit/UIKit.h>
@interface KZPhotoPickerConfig : NSObject
/**
 *  是否允许多选 默认NO
 */
@property(nonatomic,assign)BOOL allowsMultipleSelection;
/**
 *  最多选择个数 （只有在允许多选 allowsMultipleSelection =YES 才有效) 默认是不限制
 */
@property(nonatomic,assign)NSUInteger maxNumberOfSelection;

/**
 是否需要编辑（只有在允许多选 allowsMultipleSelection = NO 才有效) 默认NO
 */
@property(nonatomic,assign)BOOL isNeedEdit;
@property (nonatomic, assign) CGFloat reshapeScale; //宽高比

@property(nonatomic, strong)UIColor * navigationBarColor;
@property(nonatomic, strong)UIColor * navigationTitleColor;
@property(nonatomic, strong)UIColor * barButtonColor;
@end

