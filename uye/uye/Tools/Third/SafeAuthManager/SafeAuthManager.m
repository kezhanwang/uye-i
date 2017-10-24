//
//  SafeAuthManager.m
//  Loan
//
//  Created by Tintin on 2017/3/7.
//  Copyright © 2017年 课栈网. All rights reserved.
//

#import "SafeAuthManager.h"
//有盾

#import "UDIDSafeDataDefine.h"

typedef void(^SafeAuthResultBlock)(UDIDCheckResult result,LoanSafeAuthResultModel * userInfo);

@interface SafeAuthManager ()<UDIDSafeAuthDelegate>

@property (nonatomic, copy) SafeAuthResultBlock resultBlock;

@end

@implementation SafeAuthManager


- (void)idSafeAuthFinishedWithResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo
{
    /*
     {
     "addr_card" = "\U6cb3\U5317\U7701\U90a2\U53f0\U5e02\U67cf\U4e61\U53bf\U56fa\U57ce\U5e97\U9547\U6b63\U5143\U5bfa\U6751292\U53f7";
     "be_idcard" = "0.9602";
     "branch_issued" = "\U67cf\U4e61\U53bf\U516c\U5b89\U5c40";
     "date_birthday" = "1989.03.21";
     "flag_sex" = "\U7537";
     "id_name" = "\U5218\U5411\U6676";
     "id_no" = 130524198903214557;
     "result_auth" = T;
     "ret_code" = 000000;
     "ret_msg" = "\U4ea4\U6613\U6210\U529f";
     "start_card" = "2007.11.18-2017.11.18";
     "state_id" = "\U4e2d\U56fd";
     transcode = 1008;
     }
     */
    LoanSafeAuthResultModel * resultModel = [[LoanSafeAuthResultModel alloc] initWithDictionary:userInfo];
    if (!resultModel) {
        resultModel = [[LoanSafeAuthResultModel alloc]init];
    }
    UDIDCheckResult realResult = UDIDCheckResultFail;
    switch (result) {
        case UDIDSafeAuthResult_Done:{
            
            NSDictionary * userInfoDic = userInfo;
            NSString * resultS = [userInfoDic objectForKey:@"result_auth"];
            if ([resultS isEqualToString:@"T"]) {//认证成功
                realResult = UDIDCheckResultSuccess;
                NSString * idCardNo = resultModel.id_no;
                if ([[self getAgeFromeIdcard:idCardNo] integerValue] < 18) {
                    resultModel.ret_msg = @"申请人必须年满18周岁";
                }
            }else if ([resultS isEqualToString:@"C"]) {//人工审核
                realResult = UDIDCheckResultReview;
                NSString * idCardNo = [NSString stringWithFormat:@"%@",resultModel.id_no];
                if ([[self getAgeFromeIdcard:idCardNo] integerValue] < 18) {
                    resultModel.ret_msg = @"申请人必须年满18周岁";
                }
            }else{//人工审核的
                if ([resultModel.ret_code isEqualToString:@"000000"]) {
                    resultModel.ret_msg = @"人脸相似度低";
                    realResult = UDIDCheckResultFail;
                }
            }
            break;
        }
        case UDIDSafeAuthResult_Error: {
            resultModel.ret_msg = @"认证发生异常";
            break;
        }
        case UDIDSafeAuthResult_Cancel: {
            realResult = UDIDCheckResultCancel;

            resultModel.ret_msg = @"您已取消验证";
            break;
        }
        case UDIDSafeAuthResult_UserNameError:{
            resultModel.ret_msg = @"认证姓名不合法";
            break;
        }
        case UDIDSafeAuthResult_BillNil:{
            resultModel.ret_msg = @"认证订单为空";
            break;
        }
        case UDIDSafeAuthResult_UserIdNumberError:{
            resultModel.ret_msg = @"认证身份证号码不合法";
            break;
        }
        default:
            break;
    }
    if (self.resultBlock) {
        self.resultBlock(realResult,resultModel);
    }
}

#pragma mark - 时间获取（从2007.11.18-2017.11.18 获取：2007-11-18和2017-11-18）
- (NSString *)getStringDateWithTime:(NSString *)time isStart:(BOOL)isStart {
    NSString * timeString = @"";
    if (time.length >0) {
        NSArray * timeArray = [time componentsSeparatedByString:@"-"];
        if (timeArray.count == 2) {
            if (isStart) {
                timeString = [timeArray firstObject];
            }else{
                timeString = [timeArray lastObject];
            }
            timeString = [timeString stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        }
    }
    return timeString;
}

- (void)safeAuthFinished:(void (^)(UDIDCheckResult, LoanSafeAuthResultModel *))complete {
    self.resultBlock = complete;
}
- (UDIDSafeAuthEngine *)safeEngine {
    if (!_safeEngine) {
        _safeEngine = [[UDIDSafeAuthEngine alloc]init];
        _safeEngine.delegate = self;
        _safeEngine.showInfo = YES;
        
    }
    return _safeEngine;
}
- (NSString *)getAgeFromeIdcard:(NSString *)idcard {
        NSInteger age  = 0;
        NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
        [formatterTow setDateFormat:@"yyyy-MM-dd"];
        NSString * dataString = [self birthdayFromeIdCard:idcard];
        NSDate * currentDate =[NSDate date];
        NSString * currentDateStr = [formatterTow stringFromDate:currentDate];
        NSArray * nowArray = [currentDateStr componentsSeparatedByString:@"-"];
        NSArray * birthArray =[dataString componentsSeparatedByString:@"-"];
        
        age = [[nowArray firstObject] integerValue]-[[birthArray firstObject] integerValue];
        if ([[nowArray firstObject] integerValue]-[[birthArray firstObject] integerValue] == 18 ){
            if ([nowArray[1] integerValue] < [birthArray[1]integerValue]) {
                age = 17;
            }else if([nowArray[1] integerValue] == [birthArray[1]integerValue] && [[nowArray lastObject] integerValue] <[[birthArray lastObject] integerValue]){
                age = 17;
            }
        }
        return [NSString stringWithFormat:@"%ld",(long)age];
}
- (NSString *)birthdayFromeIdCard:(NSString *)idcard {
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([idcard length]<14)
        return result;
    
    //**截取前14位
    NSString *fontNumer = [idcard substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    year = [idcard substringWithRange:NSMakeRange(6, 4)];
    month = [idcard substringWithRange:NSMakeRange(10, 2)];
    day = [idcard substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}
//+(BOOL)handleOpenURL:(NSURL *)url {
//    return [RSAPI handleOpenURL:payURL delegate:[RSAPI shareAPI]];
//}
@end

