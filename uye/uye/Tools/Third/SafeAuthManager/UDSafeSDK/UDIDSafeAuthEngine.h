//
//  UDIDSafeAuthEngine.h
//  UD_IDShield
//
//  Created by jwtong on 16/7/21.
//  Copyright © 2016年 com.udcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDIDSafeDataDefine.h"

@protocol UDIDSafeAuthDelegate <NSObject>



@optional

/*************For OC****************
 *
 *  返回结果回调 For OC
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 *
 ***********************************/

- (void)idSafeAuthFinishedWithResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo;


/*************For Swift**************
 *
 *  返回结果回调 For Swift
 *
 *  @param result   结果信息
 *  @param userInfo 完成检测之后的返回用户信息
 *
 ***********************************/
- (void)idSafeAuthFinishedWithResult:(NSInteger)result userInfo:(id)userInfo;

@end

@interface UDIDSafeAuthEngine : NSObject

@property (weak, nonatomic) id <UDIDSafeAuthDelegate> delegate;

/**
 * 商户认证key，必传
 **/
@property (strong, nonatomic) NSString * authKey;
/**
 * 商户外部订单号，必传
 **/
@property (strong, nonatomic) NSString * outOrderId;

/**
 * 关联订单号
 */
@property (strong, nonatomic) NSString * partnerOrderId;

/**
 * 商户中的用户唯一Id
 **/
@property (strong, nonatomic) NSString * userId;
/**
 * 异步通知地址
 **/
@property (strong, nonatomic) NSString * notificationUrl;

/**
 * 商户认证信息
 **/
@property (strong, nonatomic) NSString * orderInfo;

/**
 * 拍照对比照片
 格式：UIImage 对象
 从相册中选择
 */
@property (strong, nonatomic) UIImage  * chooseImage;

/**
 * Base 64 格式的图片
 */
@property (strong, nonatomic) NSString * imageBase64String;

/**
 * 图片类型（0：正常图片、1:网格照片，默认为 0）
 */
@property (assign, nonatomic) UDIDSafePhotoType photoType;


/**
 * 默认为 NO（三组随机动作）如果设定为 YES 只有一个眨眼动作，
 */
@property (assign, nonatomic) BOOL noRandom;

/**
 * 安全模式，共3个等级，即活体检测的动作要求难度, 默认最高等级
 */
@property (assign, nonatomic) UDIDSafeMode safeMode;

/**
 * 用户手机号
 */
@property (copy, nonatomic) NSString * telephoneNumber;

/**
 * 银行卡号
 */
@property (copy, nonatomic) NSString * bankNumber;
/**
 * 是否显示身份证ocr信息,确认信息页面
 **/
@property (assign, nonatomic) BOOL showInfo;

/* 手动拍照 OCR（默认为 YES） */
@property (nonatomic, assign) BOOL isManualOCR;

/**
 * 活体的语音提示是否关闭，默认为打开，即closeRemindVoice = NO
 **/
@property (nonatomic, assign) BOOL closeRemindVoice;

/**
 * 作为备用的业务字段（预留字段，json格式，非必传）
 **/
@property (strong, nonatomic) NSString * extInfo;

/**
 *  人脸身份认证初始化
 *
 *  @param viewController 当前viewcontroller
 */
- (void)startIdSafeFaceAuthInViewController:(UIViewController *)viewController;

/**
 *  人脸身份认证初始化
 *
 *  @param aUserName       非必传，用户姓名，必须是中文。若为少数名族姓名，中间需要有间隔圆点
 *  @param aIdentityNumber 非必传，身份证号码
 *  @param aViewController 当前viewcontroller
 */
- (void)startIdSafeWithUserName:(NSString*)aUserName IdentityNumber:(NSString *) aIdentityNumber InViewController:(UIViewController*)aViewController;


/**
 *  简版人脸身份认证初始化，若不传入姓名和身份证号码，则会弹出输入框
 *
 *  @param aUserName       用户姓名，必须是中文和间隔圆点
 *  @param aIdentityNumber 身份证号码
 *  @param aViewController 当前viewcontroller
 */
- (void)startSimplifyAuthWithUserName:(NSString *)aUserName IdentityNumber:(NSString *)aIdentityNumber InViewController:(UIViewController *)aViewController;


/**
 *  人脸验证初始化接口
 *
 *  @param aViewController 当前viewcontroller
 */
- (void)startFaceAuthInViewController:(UIViewController*)aViewController;

@end
