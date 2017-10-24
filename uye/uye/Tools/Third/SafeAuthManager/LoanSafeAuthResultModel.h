//
//  LoanSafeAuthResultModel.h
//  Loan
//
//  Created by Tintin on 2017/3/7.
//  Copyright © 2017年 课栈网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanSafeAuthResultModel : NSObject
@property (nonatomic, copy) NSString * addr_card;
@property (nonatomic, copy) NSString * be_idcard;
@property (nonatomic, copy) NSString * branch_issued;
@property (nonatomic, copy) NSString * date_birthday;
@property (nonatomic, copy) NSString * flag_sex;
@property (nonatomic, copy) NSString * id_name;
@property (nonatomic, copy) NSString * id_no;
@property (nonatomic, copy) NSString * result_auth;
@property (nonatomic, copy) NSString * ret_code;
@property (nonatomic, copy) NSString * ret_msg;
@property (nonatomic, copy) NSString * start_card;
@property (nonatomic, copy) NSString * state_id;
@property (nonatomic, copy) NSString * transcode;


@property (nonatomic, copy) NSString * url_backcard;//身份证反面，国徽
@property (nonatomic, copy) NSString * url_frontcard;//身份证正面，人脸




@property (nonatomic, copy) NSString * idcard_start;
@property (nonatomic, copy) NSString * idcard_expire;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
