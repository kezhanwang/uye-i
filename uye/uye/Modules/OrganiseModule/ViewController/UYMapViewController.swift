//
//  UYMapViewController.swift
//  uye
//
//  Created by Tintin on 2017/11/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYMapViewController: UYBaseViewController {
    
    var organise :UYOrganiseModel? {
        didSet {
            navigationItem.title = organise?.org_name
            let lat = Double(organise?.map_lat ?? "0")!
            let lng = Double(organise?.map_lng ?? "0")!
            let coor = CLLocationCoordinate2DMake(lat, lng)
            zoomMapView(coords: coor)
            addAnnotation(coords: coor)
            
        }
    }
    fileprivate let locService = BMKLocationService()

    fileprivate var mapView =  BMKMapView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapViewWillAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapViewWillDisappear()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.bottom.equalTo(0);
        }
        mapView.showMapScaleBar = true
        mapView.zoomLevel = 14
        mapView.showsUserLocation = false
        mapView.userTrackingMode = BMKUserTrackingModeNone
        mapView.showsUserLocation = true
        
        locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locService.distanceFilter = 100
        locService.delegate = self
        locService.startUserLocationService()
        
    
    }
}

// MARK: - 加载地图
extension UYMapViewController {
    func mapViewWillAppear() {
        mapView.viewWillAppear()
        mapView.delegate = self
    }
    func mapViewWillDisappear()  {
        mapView.viewWillDisappear()
        mapView.delegate = nil
    }
    func zoomMapView(coords:CLLocationCoordinate2D) {
        let zoomLevel:Double = 0.2
        let region = BMKCoordinateRegion(center: coords, span: BMKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
        mapView.setRegion(region, animated: true)
        
    }
    /// 添加机构位置
    func addAnnotation(coords:CLLocationCoordinate2D)  {
        
        let point :BMKPointAnnotation = BMKPointAnnotation()
        point.coordinate = coords
        point.title = organise?.org_name

        mapView.addAnnotation(point)
    }
}
extension UYMapViewController : BMKMapViewDelegate {
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKPointAnnotation.classForCoder()) {
            let viewIdentifier = "pointIdentifier"
            let pointView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: viewIdentifier)
            pointView?.animatesDrop = true
            
            return pointView
        }
        return nil
    }
}
extension UYMapViewController :BMKLocationServiceDelegate {
    func didUpdate(_ userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        locService.stopUserLocationService()
    }
}
