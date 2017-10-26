//
//  UYHomeViewController.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import LLCycleScrollView
fileprivate let cellIdentifierTips = "tipsCellIdentifier"
fileprivate let cellIdentifierHomeOrder = "homeOrderCellIdentifier"
fileprivate let cellIdentifierHomeOrganise = "homeOrganiseCellIdentifier"
class UYHomeViewController: UYBaseViewController {
    fileprivate var tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    fileprivate let bannerView = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect(x: 0, y: 0, width: kScreenWidth, height: 150))
    fileprivate var homeModel:UYHomeModel?
    fileprivate let areaBtn = UIBarButtonItem(title: "北京", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showAreaListAction))
    
    fileprivate let buton = UIButton(type: UIButtonType.system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        NotificationCenter.default.addObserver(self, selector: #selector(getHomeData), name: MakeOrderSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getHomeData), name: LoginStatusChange, object: nil)

        if UYLocationManager.shared.allowLocationAuthorization {
            updateLocation()
        }else{
            UYLocationManager.shared.loactionAuthorizationStatusChanged {[weak self] in
                self?.updateLocation()
            }
        }
    }
    
    @objc func showAreaListAction() {
        
    }
    @objc func showMessageVC() {
        
    }
    override func setupUI() {
        
        
        let textField = UYSearchBar()
        textField.delegate = self
        textField.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 30)
        textField.homeStyle()
        navigationItem.titleView = textField

        navigationItem.leftBarButtonItem = areaBtn
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "user_msg_read_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMessageVC))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaHeight)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-(tabBarController?.tabBar.frame.height)!)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib(nibName: "UYHomeTipsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierTips)
        tableView.register(UINib(nibName: "UYHomeOrderTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierHomeOrder)
        tableView.register(UINib(nibName: "UYHomeOrganiseTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierHomeOrganise)
    
        tableView.tableFooterView = UIView()
        bannerView.autoScrollTimeInterval = 5
        tableView.tableHeaderView = bannerView
    }

   
}

// MARK: - 获取数据
extension UYHomeViewController {
    func updateLocation() {
        UYLocationManager.shared.beginUpdataLocation(complete: {[weak self] (success) -> (Void) in
            self?.getHomeData()
        })
    }
    @objc func getHomeData() {
        showWaitToast()
        request.getHomeData {[weak self] (data:UYHomeModel?, error : UYError?) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                self?.homeModel = data
                self?.tableView.reloadData()
                self?.updateBannerView()
            }
        }
    }
    func updateBannerView() {
        if let areaTitle = homeModel?.loaction {
            areaBtn.title = "\(areaTitle)    "
        }
        if let adArray:[UYAdModle] = homeModel?.ad_list {
            var urlArray:[String] = []
            
            for adModel in adArray {
                urlArray.append(adModel.logo ?? "")
            }
            DispatchQueue.main.async {[weak self] in
                self?.bannerView.imagePaths = urlArray
            }
        }
        
        
       
    }
}
extension UYHomeViewController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTips, for: indexPath) as! UYHomeTipsTableViewCell
            
            if let tips:String = homeModel?.count_order {
                let scnner = Scanner(string:tips)
                var number:Int = 0
                scnner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
                scnner.scanInt(&number)
                let str:String = "\(number)"

                let startIndex =  (tips as NSString).range(of: str)
                let attributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),
NSAttributedStringKey.foregroundColor:UIColor.blackText]
                
                let mutableAttributedString = NSMutableAttributedString(string: tips, attributes: attributes)
            mutableAttributedString.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.orangeText], range: startIndex)
                cell.tipsLabel.attributedText = mutableAttributedString
                
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierHomeOrder, for: indexPath) as! UYHomeOrderTableViewCell
            if let order = homeModel?.insured_order {
                cell.setupUI(order: order, premiumTop: homeModel?.premium_amount_top ?? 0)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierHomeOrganise, for: indexPath) as! UYHomeOrganiseTableViewCell
            cell.delegate = self
            if let organise = homeModel?.organize {
                cell.setupUI(organise: organise)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 31
        }
        if indexPath.section == 1 {
            return 240
        }
        return 199
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 5
        }
        return 0.1
    }
}
extension UYHomeViewController : UYHomeOrganiseTableViewCellDelegate,UITextFieldDelegate {
    func hoemSiginAction() {
//        let orderVC = UYPlaceOrderViewController()
//        orderVC.order_id = "10049"
//        pushToNextVC(nextVC: orderVC)
//        return
        
        if let organise = homeModel?.organize {
            let quesVC = UYQuestionnaireViewController()
            quesVC.org_id = organise.org_id
            pushToNextVC(nextVC: quesVC)
        }
        
    }
    
    func homeSearchAction() {
//        let orderVC = UYPlaceOrderViewController()
//        orderVC.order_id = "10049"
//        pushToNextVC(nextVC: orderVC)
       pushToNextVC(nextVC: UYSearchViewController())
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        homeSearchAction()
        return false
    }
    
}
