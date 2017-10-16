//
//  UYLocationManager.swift
//  uye
//
//  Created by Tintin on 2017/10/13.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

typealias UYLocationBlock = (_ success:Bool)->(Void)
typealias UYLocationAuthorizationBlock = ()->(Void)

class UYLocationManager: NSObject {
    
    fileprivate let locationMgr = CLLocationManager()
    fileprivate let locService = BMKLocationService()
    fileprivate var locationBlock :UYLocationBlock? = nil
    fileprivate var authorizationBlock :UYLocationAuthorizationBlock? = nil
    var allowLocationAuthorization :Bool {
        let status =  CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            return true
        }
        return false
    }
    var longitude:String = ""
    var latitude:String = ""
    
    var blockTime :Int = 0
    
    /// 以下是单例的一种写法
    
    static let shared = UYLocationManager()
    /// 将init方法私有化了,这样在其他地方就无法init

    private override init() {
        super.init()
        locationMgr.delegate = self
       
        
        locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locService.distanceFilter = 100
        locService.delegate = self
    }
    
    func requstAuthorization() {
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.requestAlwaysAuthorization()
    }
    
    func beginUpdataLocation(complete:UYLocationBlock? = nil )  {
        locationBlock = complete
        blockTime = 0
        locService.startUserLocationService()
    }
    
    func loactionAuthorizationStatusChanged(complete:UYLocationAuthorizationBlock? = nil) {
        authorizationBlock = complete;
    }
    
}
extension UYLocationManager : CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (authorizationBlock != nil) {
            authorizationBlock!()
        }
    }
}
extension UYLocationManager : BMKLocationServiceDelegate {
	func didUpdate(_ userLocation: BMKUserLocation!) {
        
        longitude = String(userLocation.location.coordinate.longitude)
        latitude =  String(userLocation.location.coordinate.latitude)
        
        if (locationBlock != nil && blockTime == 0) {
            
            blockTime += 1
            locationBlock!(true)
        }
    }
    func didFailToLocateUserWithError(_ error: Error!) {
        if (locationBlock != nil) {
            locationBlock!(false)
        }
    }
}

