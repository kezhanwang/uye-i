//
//  PhotoDataManager.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoModel.h"
@interface PhotoDataManager : NSObject
- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection;

- (NSInteger)numberOfItems;
/**
 * @brief 获取指定相册内的所有图片
 */
- (NSArray<PhotoModel *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;
- (PhotoModel * )cellModelWithIndex:(NSIndexPath *)indexPath;

/**
 * @brief 获取每个Asset对应的图片
 */
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;

@end
