//
//  UDIDSafeOCREngine.h
//  UD_IDShield
//
//  Created by jwtong on 16/7/21.
//  Copyright © 2016年 com.udcredit. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UDIDSafeDataDefine.h"

@protocol UDIDOcrScanDelegate <NSObject>
/**
 *  返回结果回调
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 */
- (void)idSafeOcrScanFinishedWithResult:(UDIDSafeAuthResult)result userInfo:(id)userInfo;

@end


@interface UDIDSafeOCREngine : NSObject

@property (nonatomic, weak) id<UDIDOcrScanDelegate> delegate;
/**
 * 商户认证key，必传，从服务端获取
 **/
@property (nonatomic, strong) NSString * authKey;

/**
 * 商户外部订单号，必传
 **/
@property (strong, nonatomic) NSString * outOrderId;

/**
 * OCR手动上传功能，默认为关闭，即takedBySelf = NO
 **/
@property (nonatomic, assign) BOOL takedBySelf;

/**
 * 作为备用的业务字段（预留字段，json格式，非必传）
 **/
@property (strong, nonatomic) NSString * extInfo;

/**
 *  身份证信息识别OCR
 *
 *  @param viewController 当前viewcontroller
 */

- (void)startOcrScanIdentityCardInViewController:(UIViewController *)viewController;

@end
