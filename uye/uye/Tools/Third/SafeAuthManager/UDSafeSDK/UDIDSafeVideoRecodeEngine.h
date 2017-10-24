//
//  UDIDSafeVideoRecodeEngine.h
//  UD_IDShield
//
//  Created by jwtong on 16/7/21.
//  Copyright © 2016年 com.udcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UDIDSafeDataDefine.h"

typedef NS_ENUM(NSInteger, UDSafeVideoUploadType) {
    UDSafeVideoUploadTypeNormal,
    UDSafeVideoUploadTypeDirect, // 直接上传，不需要比对
    UDSafeVideoUploadTypeUserUpload // 用户上传
};


@protocol UDIDSafeVideoRecodingDelegate <NSObject>

@optional

/************For OC****************
 *
 *  返回结果回调 For OC
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 *
 *********************************/
- (void)idSafeRecordingFinishedResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo;


/***********For Swift****************
 *
 *  返回结果回调 For Swift
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 */
- (void)idSafeRecordingFinishedResult:(NSInteger)result userInfo:(id)userInfo;

@end

@interface UDIDSafeVideoRecodeEngine : NSObject

@property (nonatomic, assign) id <UDIDSafeVideoRecodingDelegate> delegate;

/**
 * 商户认证key，必传
 **/
@property (strong, nonatomic) NSString * authKey;
/**
 * 商户中的用户唯一Id
 **/
@property (strong, nonatomic) NSString * userId;
/**
 * 异步通知地址
 **/
@property (strong, nonatomic) NSString * notificationUrl;

/**
 * 视频内需要朗读的文字内容,数字限制在100字以内，多余部分不显示
 **/
@property (strong, nonatomic) NSString * readingInfo;

/**
 * 拍摄视频的质量, 默认为高
 * 建议设置为低质量即lowPreset = YES, 可有效降低视频的大小，节省用户流量
 **/
@property (assign, nonatomic) BOOL lowPreset;

/**
 * 外部订单号
 **/
@property (strong, nonatomic) NSString * outOrderId;


/**
 * 关联订单号
 */
@property (strong, nonatomic) NSString * partnerOrderId;

/**
 * 外部订单时间
 格式：YYYYMMDDHHMMSS,
 示例：20160721203625
 **/
@property (strong, nonatomic) NSString * outOrderTime;

/**
 * 作为备用的业务字段（预留字段，json格式，非必传）
 **/
@property (strong, nonatomic) NSString * extInfo;


/**
 * 商家上传照片 
 格式：UIImage 对象
 从相册中选择
 */
@property (strong, nonatomic) UIImage  * chooseImage;

/**
 *  视频存证
 *
 *  @param viewController 当前viewcontrller
 */
- (void)startRecodingVideoInViewController:(UIViewController *)viewController;

//- (void)startRecodingVideoInViewController:(UIViewController *)viewController ;

@end
