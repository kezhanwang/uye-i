//
//  PhotoDataManager.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoDataManager.h"
@interface PhotoDataManager ()
@property (nonatomic,strong)NSMutableArray <PhotoModel *> *photoArray;
@end

@implementation PhotoDataManager
- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection
{
    self = [super init];
    if (self) {
        self.photoArray = [NSMutableArray arrayWithArray:[self getAssetsInAssetCollection:assetCollection ascending:YES]];
    }
    return self;
}

- (NSInteger)numberOfItems {
    return self.photoArray.count;
}
- (PhotoModel *)cellModelWithIndexPath:(NSIndexPath *)indexPath {
    return [self.photoArray objectAtIndex:indexPath.item];
}

- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}


#pragma mark - 获取指定相册内的所有图片
- (NSArray<PhotoModel *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PhotoModel *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            PhotoModel * photoModel = [[PhotoModel alloc]init];
            photoModel.asset = obj;
            photoModel.isSelect = NO;
            [arr addObject:photoModel];
        }
    }];
    return arr;
}
- (PhotoModel *)cellModelWithIndex:(NSIndexPath *)indexPath {
    return self.photoArray[indexPath.item];
}
#pragma mark - 获取asset对应的图片
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = resizeMode;//控制照片尺寸
//    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
//    option.synchronous = YES;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        
        // PHImageResultIsDegradedKey 为0 是高质量图片  1低质量图片
        if ([[info valueForKey:@"PHImageResultIsDegradedKey"]integerValue]==0){
            completion(image);
        }

    }];
}
@end
