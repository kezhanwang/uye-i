//
//  KZPhotoPicker.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "KZPhotoPicker.h"

typedef void(^KZPhotoPickerHandler)(NSArray *photos,NSError *error,BOOL isCamera);
@interface KZPhotoPicker ()<UIImagePickerControllerDelegate>
{
    BOOL _isCamera;
}
@property (nonatomic,copy)KZPhotoPickerHandler photoPickerHandler;
@end
#import "UIImage+Reshape.h"
#import <UIKit/UIKit.h>
#import "PhotoNavigationController.h"
#import "XJActionSheet.h"
#import "EditPhotoViewController.h"

@implementation KZPhotoPicker
- (instancetype)initWithConfig:(KZPhotoPickerConfig *)config {
    NSParameterAssert(config);
    self = [super init];
    if (self) {
        _isCamera = NO;
        self.config = config;
    }
    return self;
}
- (void)showPhotoPickerComplete:(void (^)(NSArray *, NSError *, BOOL))complete {
    if (complete) {
        self.photoPickerHandler = complete;
    }
    [self showPhotoAlbum];
    
}
- (void)showCameraComplete:(void(^)(NSArray *photos,NSError * error,BOOL isCamera))complete {
    if (complete) {
        self.photoPickerHandler = complete;
    }
    [self showCamera];
}
- (void)showPhotoPickerActionSheetShowTitle:(BOOL)showTitle complete:(void (^)(NSArray *, NSError *, BOOL))complete {
    if (complete) {
        self.photoPickerHandler = complete;
    }
    NSString * title;
    if (showTitle) {
        title = [NSString stringWithFormat:@"最多选择%lu张",(unsigned long)self.config.maxNumberOfSelection];
    }
    
    XJActionSheet * actionSheet = [[XJActionSheet alloc]initWithTitle:title cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    __weak typeof(self)weakSelf = self;
   [actionSheet showActionSheetWithHandle:^(NSInteger buttonIndex) {
       switch (buttonIndex) {
           case -1:
               [weakSelf cancelButtonClick];
               break;
           case 0:{
               [self showPhotoAlbum];
               break;
           }
           case 1:{
               [self showCamera];
               break;
           }
           default:
               break;
       }
   }];
}
#pragma mark 调取相册
- (void)showPhotoAlbum {
    _isCamera = NO;
    PhotoNavigationController * pickerNavi =[[PhotoNavigationController alloc]initWithPickerConfig:self.config];
    __weak typeof(self)weakSelf = self;
    __weak typeof(pickerNavi)weakNavi = pickerNavi;
    [pickerNavi selectPhotoComplete:^(NSArray *photos, KZPhotoPickerError error) {
        if (error == KZPhotoPickerSuccess && weakSelf.config.isNeedEdit) {
            [weakSelf showEditControllerInNavi:weakNavi sourceImage:photos.firstObject];
        }else{
            [weakSelf completePickerWithPhotos:photos errorCode:error];
            [weakNavi dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
    UIViewController * rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:pickerNavi animated:YES completion:NULL];

}
#pragma mark 调取相机
- (void)showCamera {
    _isCamera = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePickerControllerSourceTypeCamera
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePicker.view.backgroundColor = [UIColor blackColor];
        imagePicker.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
        UIViewController * rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

        [rootVC presentViewController:imagePicker animated:YES completion:NULL];
    }else{
        [self completePickerWithPhotos:@[] errorCode:KZPhotoPickerCameraPermissions];
        [self showPermissionAlertViewWithCode:KZPhotoPickerCameraPermissions];
    }
}
#pragma mark - 相机拍照回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * temp = [info objectForKey: UIImagePickerControllerEditedImage];
    if ([temp isEqual:[NSNull null]] || !temp) {
        temp = [info objectForKey: UIImagePickerControllerOriginalImage];
    }
    if (self.config.isNeedEdit) {
        [self showEditControllerInNavi:picker sourceImage:temp];
    }else{
        temp = [UIImage compressImageWithImage:temp compressWidth:CGRectGetWidth([UIScreen mainScreen].bounds)*3];
        [self completePickerWithPhotos:@[temp] errorCode:KZPhotoPickerSuccess];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self completePickerWithPhotos:@[] errorCode:KZPhotoPickerUserCancel];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark 进入编辑界面
- (void)showEditControllerInNavi:(UINavigationController *)controller sourceImage:(UIImage*)sourceImage {
    EditPhotoViewController * editPhtoVC = [[EditPhotoViewController alloc]init];
    editPhtoVC.sourceImage = sourceImage;
    editPhtoVC.reshapeScale = self.config.reshapeScale;
    __weak typeof(self)weakSelf = self;
    __weak typeof(editPhtoVC)weakEditer = editPhtoVC;
    [editPhtoVC editPhotoFinish:^(UIImage *shapeImage, NSInteger code) {
        if (code == KZPhotoPickerUserCancel) {
            [weakSelf completePickerWithPhotos:@[] errorCode:code];
        }else{
            [weakSelf completePickerWithPhotos:@[shapeImage] errorCode:code];
        }
        [weakEditer dismissViewControllerAnimated:YES completion:NULL];
    }];
    [controller pushViewController:editPhtoVC animated:YES];
}

#pragma mark 用户点击了取消按钮
- (void)cancelButtonClick {
    [self completePickerWithPhotos:@[] errorCode:KZPhotoPickerUserCancel];
}
#pragma mark - 所有的回调都走此接口
- (void)completePickerWithPhotos:(NSArray *)photos errorCode:(KZPhotoPickerError)error {
    if (self.photoPickerHandler) {
        if (photos.count > 0) {
            self.photoPickerHandler(photos,[self pickerErrorWithCode:error],_isCamera);
        }else{
            if (error == KZPhotoPickerUserCancel) {
                self.photoPickerHandler(photos,[self pickerErrorWithCode:KZPhotoPickerUserCancel],_isCamera);
            }else{
                self.photoPickerHandler(photos,[self pickerErrorWithCode:KZPhotoPickerPhotoReadFail],_isCamera);
            }
        }
    }
}
#pragma mark 展示权限不足的提示框
- (void)showPermissionAlertViewWithCode:(KZPhotoPickerError)erroeCode {
    NSString * titleStr = @"";
    NSString * erroeMsg = @"";
    if (erroeCode == KZPhotoPickerCameraPermissions) {
        titleStr = @"相机权限不足";
        erroeMsg = @"请在设置中启用";
    }else if (erroeCode == KZPhotoPickerAlbumPermissions){
        titleStr = @"相册权限不足";
        erroeMsg = @"请在设置中启用";
    }else{
        return;
    }
    UIAlertController * alertControlelr = [UIAlertController alertControllerWithTitle:titleStr message:erroeMsg preferredStyle:UIAlertControllerStyleAlert];
    [alertControlelr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    UIViewController * rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:alertControlelr animated:YES completion:NULL];
}
#pragma mark - 错误信息生成Error
- (NSError *)pickerErrorWithCode:(KZPhotoPickerError)erroeCode {
    NSString * errorDomain;
    switch (erroeCode) {
        case KZPhotoPickerSuccess:{
            return nil;
            break;
        }
        case KZPhotoPickerUserCancel:
            errorDomain = @"用户取消了选择";
            break;
        case KZPhotoPickerErrorUnknown:{
            errorDomain = @"发生了未知错误";
            break;
        }
        case KZPhotoPickerAlbumPermissions:{
            errorDomain = @"相册权限不足，请在设置中打开";
            break;
        }
        case KZPhotoPickerCameraPermissions:{
            errorDomain = @"相机权限不足，请在设置中打开";
            break;
        }
        case KZPhotoPickerPhotoReadFail:{
            errorDomain = @"图片读取失败了，换一张试试";
            break;
        }
        default:
            break;
    }
    return [NSError errorWithDomain:errorDomain code:erroeCode userInfo:nil];

}

@end
