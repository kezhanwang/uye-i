//
//  UYUserInfoViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
let userInfoIdetifier = "userInfoIdentifier"
class UYUserInfoViewController: UYBaseViewController {
    var order_id :String = ""
    fileprivate var userInfoConfig:UYUserInfoStatus?
    fileprivate var itemArray :[UYUserStatusModel] = []
    fileprivate let tableView : UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserStatusInfo()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocalData()
        navigationItem.title = "个人资料"
    }
    func loadLocalData() {
        var itemOne = UYUserStatusModel()
        itemOne.itemIcon = "user_id_icon"
        itemOne.title = "身份信息"
        itemOne.detail = "身份信息、银行卡、联系方式等"
        itemOne.isOptional = false
        itemOne.isCertified = false
        itemOne.placeholder = "请认证身份信息"
        var phoneBook = UYUserStatusModel()
        phoneBook.itemIcon = "user_phone_book_icon"
        phoneBook.title = "手机通讯信息"
        phoneBook.detail = "本机通讯录"
        phoneBook.isOptional = false
        phoneBook.isCertified = false
        phoneBook.placeholder = "请认证更新通讯录信息"
        itemArray.append(itemOne)
        itemArray.append(phoneBook)
    }
    override func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.bottom.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        
        tableView.register(UINib(nibName: "UYUserInfoTableCell", bundle: nil), forCellReuseIdentifier: userInfoIdetifier)
        
        let footView = UYTableFooterView(title: "下一步")
        footView.delegate = self
        tableView.tableFooterView = footView
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.rowHeight = 76
        
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension UYUserInfoViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userInfoIdetifier, for: indexPath) as! UYUserInfoTableCell
        cell.setupUI(itemInfo: itemArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            getUserInfo()
        }else if indexPath.row == 1 {
            submitUserMobie()
        }
    }
}

// MARK: - 下一步按钮
extension UYUserInfoViewController :UYTableFooterViewDelegate {
    func checkUserStatus() -> Bool {
        
    
        for status in itemArray {
            if status.isCertified == false {
                showTextToastAutoDismiss(msg: status.placeholder)
                return false
            }
        }
        return true
    }
    func footButtonAction() {
        guard checkUserStatus() else {
            return
        }
        
        let placeOrderVC = UYPlaceOrderViewController()
        placeOrderVC.order_id = self.order_id
        pushToNextVC(nextVC: placeOrderVC)
    }
}

// MARK: - 网络请求
extension UYUserInfoViewController {
    func getUserStatusInfo() {
        showWaitToast()
        request.getUsetInfoStatus { [weak self] (infoStatus, error) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                if var status = self?.itemArray.first {
                    status.isCertified = (infoStatus?.identity)!
                    self?.itemArray[0] = status
                    self?.tableView.reloadData()
                }
                
            }
        }
    }
    func getUserInfo()  {
        showWaitToast()
        request.getUserInfoRequest {[weak self] (userInfo, error) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                UYAPPManager.shared.userInfo?.full_name = userInfo?.full_name ?? ""
                UYAPPManager.shared.userInfo?.id_card = userInfo?.id_card ?? ""
                UYAPPManager.shared.userInfo?.id_card_start = userInfo?.id_card_start ?? ""
                UYAPPManager.shared.userInfo?.id_card_end = userInfo?.id_card_end ?? ""
                UYAPPManager.shared.userInfo?.id_card_address = userInfo?.id_card_address ?? ""
                UYAPPManager.shared.userInfo?.id_card_info_pic = userInfo?.id_card_info_pic ?? ""
                UYAPPManager.shared.userInfo?.id_card_nation_pic = userInfo?.id_card_nation_pic ?? ""
                UYAPPManager.shared.userInfo?.auth_mobile = userInfo?.auth_mobile ?? ""
                UYAPPManager.shared.userInfo?.bank_card_number = userInfo?.bank_card_number ?? ""
                UYAPPManager.shared.userInfo?.open_bank_code = userInfo?.open_bank_code ?? ""
                UYAPPManager.shared.userInfo?.open_bank = userInfo?.open_bank ?? ""
            }
            self?.pushToNextVC(nextVC: UYUserBaseInfoViewController())
        }
    }
    func submitUserMobie()  {
        showWaitToast()
        UYAddressBookManager.shared.uploadAddressBook {[weak self] (scc, errorMsg) in
            self?.dismissToast()
            if var status = self?.itemArray.last {
                status.isCertified = scc
                self?.itemArray[1] = status
                self?.tableView.reloadData()
            }

        }
    }
}
