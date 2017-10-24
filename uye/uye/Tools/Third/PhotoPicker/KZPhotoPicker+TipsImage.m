//
//  KZPhotoPicker+TipsImage.m
//  KZW_iPhone2
//
//  Created by Tintin on 2017/1/5.
//  Copyright © 2017年 课栈网. All rights reserved.
//

#import "KZPhotoPicker+TipsImage.h"
#import "XJActionSheet+ImagePicker.h"
@implementation KZPhotoPicker (TipsImage)
- (void)showActionSheetFromViewController:(UIViewController *)controller TipsImage:(NSString *)imageName complete:(void (^)(NSArray *, NSError *, BOOL))complte {
    

    XJActionSheet * sheet =[[XJActionSheet alloc]initWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"拍照",@"从相册里选", nil];
    sheet.backgroundColor =[UIColor colorWithWhite:0 alpha:0.7f];
    [sheet showActionSheetWithImageTips:imageName handle:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self showCameraComplete:complte];
        }else if (buttonIndex == 1){
            [self showPhotoPickerComplete:complte];
        }
    }];
}
- (void)showLoanImagePickerFromViewController:(UIViewController *)controller tipsImage:(NSString *)imageName complete:(void (^)(NSArray *, NSError *, BOOL))complte {
 
    XJActionSheet * sheet =[[XJActionSheet alloc]initWithTitle:nil
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"拍照",@"从相册里选", nil];
    sheet.backgroundColor =[UIColor colorWithWhite:0 alpha:0.7f];
    [sheet showActionSheetWithImageTips:imageName handle:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self showCameraComplete:complte];
        }else if (buttonIndex == 1){
            [self showPhotoPickerComplete:complte];
        }
    }];
}
@end
