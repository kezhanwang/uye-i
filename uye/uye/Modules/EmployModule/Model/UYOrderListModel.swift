//
//  UYOrderListModel.swift
//  uye
//
//  Created by Tintin on 2017/10/21.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrderListModel: UYBaseModel {
    var page:UYPageModel?
    var insured_order:UYOrderModel?
    
}
class UYOrderModel: UYBaseModel {
    
    /// 保单号
    var insured_order:String?
    /// 保单状态
    var insured_status:Int = 0
    /// 保单状态描述
    var insured_status_desp:String?
    
    /// 机构名称
    var org_name:String?
    var org_logo:String?
    /// 保单类型
    var insured_type:String?
    
    /// 学费，单位：分
    var tuition:Double?
    
    /// 备注信息
    var remark:String?
    
    /// 最好赔付金额，单位：分
    var premium_amount_top:Double?
    
    /// 择业期
    var career_time:String?
    
    /// 赔付期
    var repay_time:String?
    /// 培训时间记录
    var train:UYTrainModel?
    
}
class UYTrainModel: UYBaseModel {
    
    /// 培训日期
    var first_train:String?
    
    /// 再培训日期
    var second_train:String?
    
    /// 毕业日期
    var end_train:String?

}
enum UYOrderStatus : Int {
    case unkonow = 0
    /// 订单审核中
    case inReviewOrder = 100
    /// 投保中
    case inInsurance = 150
    /// 审核拒绝
    case rejectOrder = 151
    /// 培训中
    case inTraining = 200
    /// 择业中
    case inChoosingCareer = 300
    /// 等待申请理赔
    case waitingApplyClaims = 400
    /// 审核申请的理赔
    case inReviewClaims = 500
    ///赔付中
    case inPaying = 600
    ///拒绝理赔
    case rejectClaims = 650
    /// 赔付结束
    case payFinish = 700
    /// 订单取消
    case orderCancel = 800
    /// 已就业
    case haveJobs = 820
    ///超过理赔期限
    case timeOut = 20
    
}
