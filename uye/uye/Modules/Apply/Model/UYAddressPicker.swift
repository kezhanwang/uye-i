//
//  UYAddressPicker.swift
//  uye
//
//  Created by Tintin on 2017/10/30.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
typealias AddressPickHandler = (UYAddress?,UYAddress?,UYAddress?) -> (Void)
class UYAddressPicker: NSObject {
    fileprivate var provinceArray = [UYAddress]()
    fileprivate var cityArray = [UYAddress]()
    fileprivate var areaArray = [UYAddress]()
    fileprivate let selectView = MultiSelectView()
    fileprivate var selectedProvince:UYAddress?
    fileprivate var selectedCity:UYAddress?
    fileprivate var addressHandler :AddressPickHandler?
    fileprivate let request = UYNetRequest()
    override init() {
        super.init()
        selectView.title = "请选择地址"
        selectView.dataSource = self
        getProvinceList()
    }
    func showAddressPicker(_ complete: @escaping AddressPickHandler) {
        addressHandler = complete
        selectView.showMultiSelectiView()
    }
}
extension UYAddressPicker :MultiSelectViewDataSource {
    func numberOfRows(inSelectViewIndex index: Int) -> Int {
        if (index == 0) {
            return provinceArray.count;
        }
        if (index == 1) {
            return cityArray.count;
        }
        if (index == 2) {
            return areaArray.count;
        }
        return 0;
    }
    
    func title(withRow row: Int, selectViewIndex index: Int) -> String! {
       let address = addressModel(row: row, index: index)
        return address?.name ?? ""
    }
    
    func haveNextSelectView(withDidSelectedRow row: Int, selectViewIndex index: Int) -> Bool {
        let address = addressModel(row: row, index: index)
        guard address != nil else { return false }
        if index == 0 {
            selectedProvince = address!
            getCityList(provinceId: (address?.id!)!)
        }
        if index == 1 {
            selectedCity = address!
            getAredList(cityId: (address?.id!)!)
        }
        if index == 2 {
            if addressHandler != nil {
                addressHandler!(selectedProvince,selectedCity,address!)
            }
            selectView.dismissMultiSelectiView()
        }
        
        if index < 2 { return true }
        return false
        
    }
}

// MARK: - 本地数据逻辑
extension UYAddressPicker {
    func addressModel(row:Int,index:Int) -> UYAddress? {
        if index == 0 {
            if provinceArray.count > row {
                return provinceArray[row]
            }
        }
        if index == 1 {
            if cityArray.count > row {
                return cityArray[row]
            }
        }
        if index == 2 {
            if areaArray.count > row {
                return areaArray[row]
            }
        }
        return nil
    }
}

// MARK: - 网络请求
extension UYAddressPicker {
    func getProvinceList()  {
        SRToast.shared.showToastView()
        request.getProvinceList {[weak self] (provinces, error) -> (Void) in
            self?.handleRequest(results: provinces, error: error, cityType: 1)
        }
    }
    func getCityList(provinceId:String)  {
        SRToast.shared.showToastView()
        request.getCityList(province: provinceId) {[weak self] (citys, error) -> (Void) in
            self?.handleRequest(results: citys, error: error, cityType: 2)
        }
    }
    func getAredList(cityId:String) {
        SRToast.shared.showToastView()
        request.getAreaList(city: cityId) {[weak self] (areas, error) -> (Void) in
            self?.handleRequest(results: areas, error: error, cityType: 3)
        }
    }
    func handleRequest(results:[UYAddress]?,error:UYError?,cityType:NSInteger) {
        if  error != nil {
            SRToast.shared.showTextToastAutoDismiss(msg: (error?.description)!)
        }else{
            SRToast.shared.dismissToast()
            if cityType == 1 {
                provinceArray.removeAll()
                provinceArray +=  results!
            }else if cityType == 2{
                cityArray.removeAll()
                cityArray += results!
            }else if cityType == 3{
                areaArray.removeAll()
                areaArray += results!
            }
            selectView.reloadDate(withColumnIndex: cityType - 1)
        }
    }
}
