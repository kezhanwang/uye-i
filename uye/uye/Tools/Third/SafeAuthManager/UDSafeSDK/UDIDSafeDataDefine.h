//
//  UDIDSafeDataDefine.h
//  UD_IDShield
//
//  Created by jwtong on 16/7/21.
//  Copyright © 2016年 com.udcredit. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UDIDSafeAuthResult) {
    UDIDSafeAuthResult_Done,                //认证完成，商户可根据返回码进行自己的业务逻辑操作
    UDIDSafeAuthResult_Error,               //认证异常，如网络异常等
    UDIDSafeAuthResult_Cancel,              //用户取消认证操作
    UDIDSafeAuthResult_UserNameError,       //商户传入的姓名不合法
    UDIDSafeAuthResult_UserIdNumberError,   //商户传入 的身份证号码不合法
    UDIDSafeAuthResult_BillNil              //订单为空
};

typedef NS_ENUM(NSUInteger, UDIDSafeMode) {
    UDIDSafeMode_High,
    UDIDSafeMode_Medium,
    UDIDSafeMode_Low
};

typedef NS_ENUM(NSUInteger, UDIDSafePhotoType) {
    UDIDSafePhotoTypeNormal,                // 正常图片
    UDIDSafePhotoTypeGrid                   // 网格照片
};
