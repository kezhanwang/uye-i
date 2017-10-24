//
//  LoanSafeAuthResultModel.m
//  Loan
//
//  Created by Tintin on 2017/3/7.
//  Copyright © 2017年 课栈网. All rights reserved.
//

#import "LoanSafeAuthResultModel.h"

@implementation LoanSafeAuthResultModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.addr_card = [NSString stringWithFormat:@"%@",dict[@"addr_card"]];
        self.be_idcard = [NSString stringWithFormat:@"%@",dict[@"be_idcard"]];
        self.branch_issued = [NSString stringWithFormat:@"%@",dict[@"branch_issued"]];
        self.date_birthday = [NSString stringWithFormat:@"%@",dict[@"date_birthday"]];
        self.id_name = [NSString stringWithFormat:@"%@",dict[@"flag_sex"]];
        self.id_no = [NSString stringWithFormat:@"%@",dict[@"id_no"]];
        self.result_auth = [NSString stringWithFormat:@"%@",dict[@"result_auth"]];
        self.ret_code = [NSString stringWithFormat:@"%@",dict[@"ret_code"]];
        self.ret_msg = [NSString stringWithFormat:@"%@",dict[@"ret_msg"]];
        self.start_card = [NSString stringWithFormat:@"%@",dict[@"start_card"]];
        self.state_id = [NSString stringWithFormat:@"%@",dict[@"state_id"]];
        
        self.url_backcard = [NSString stringWithFormat:@"%@",dict[@"url_backcard"]];
        self.url_frontcard = [NSString stringWithFormat:@"%@",dict[@"url_frontcard"]];
    
        
        NSString * idcardStarEnd = self.start_card;
        NSArray <NSString *>* timeArray = [idcardStarEnd componentsSeparatedByString:@"-"];
        if (timeArray.count == 2) {
            self.idcard_start = [[timeArray firstObject] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            self.idcard_expire = [[timeArray lastObject] stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        }
    }
    return self;
}

@end
