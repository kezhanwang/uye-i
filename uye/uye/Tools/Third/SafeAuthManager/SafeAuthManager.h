//
//  SafeAuthManager.h
//  Loan
//
//  Created by Tintin on 2017/3/7.
//  Copyright © 2017年 课栈网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UDIDSafeAuthEngine.h"
#import "LoanSafeAuthResultModel.h"


typedef NS_ENUM(NSUInteger, UDIDCheckResult) {
    UDIDCheckResultSuccess = 0,//成功
    UDIDCheckResultFail = 1,//失败
    UDIDCheckResultReview = 2,//人工审核
    UDIDCheckResultCancel = 3 //用户取消
};

@interface SafeAuthManager : NSObject

@property (nonatomic, strong) UDIDSafeAuthEngine * safeEngine;


- (void)safeAuthFinished:(void(^)(UDIDCheckResult result,LoanSafeAuthResultModel * userInfo))complete;
//+ (BOOL)handleOpenURL:(NSURL*)url;
@end
