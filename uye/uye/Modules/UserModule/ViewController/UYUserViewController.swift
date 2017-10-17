//
//  UYUserViewController.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
let UserCellIdentifier :String = "UYUserTableViewCellIdentifier"
let UserItemCellIdentifier = "UYCustomSimpleTableCellIdentifier"

class UYUserViewController: UYBaseViewController {
    fileprivate let tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    fileprivate let iconArray = ["user_clear_icon","user_contact_us_icon"]
    fileprivate let nameArray = ["清除缓存","联系我们"]
    fileprivate let footerView = UYTableFooterView(title: "登录/注册")
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if UYAPPManager.shared.userInfo != nil {
            footerView.title = "退出登录"
        }else{
            footerView.title = "登录/注册"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人中心"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "user_msg_read_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMessageVC))
    }
    @objc func showMessageVC() {
        
    }
    override func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 10
        tableView.backgroundColor = UIColor.background
        tableView.tableHeaderView = UIView()
        
        footerView.delegate = self
        tableView.tableFooterView = footerView
        
        tableView.register(UINib(nibName: "UYUserTableViewCell", bundle: nil), forCellReuseIdentifier: UserCellIdentifier)
        tableView.register(UINib(nibName: "UYCustomSimpleTableCell", bundle: nil), forCellReuseIdentifier: UserItemCellIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "V-\(appVersion)"
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20-(tabBarController?.tabBar.frame.height)!)
            make.centerX.equalTo(kScreenWidth/2)
        }
        
        
    }
}
extension UYUserViewController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return iconArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell :UYUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: UserCellIdentifier, for: indexPath) as! UYUserTableViewCell
            cell.setupUI()
            return cell
        }else{
            let cell :UYCustomSimpleTableCell = tableView.dequeueReusableCell(withIdentifier: UserItemCellIdentifier, for: indexPath) as! UYCustomSimpleTableCell
            cell.iconView.image = UIImage(named: iconArray[indexPath.row])
            cell.nameLabel.text = nameArray[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 121
        }
        return 55
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            cell.separatorInset = UIEdgeInsetsMake(0, UIScreen.main.bounds.width, 0, 0)
            cell.layoutMargins = UIEdgeInsetsMake(0, UIScreen.main.bounds.width, 0, 0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 0  {
                showWaitToastAutoDismiss(msg: "清理中...", second: 1)
            }
            if indexPath.row == 1 {
                DispatchQueue.main.async {
                    UIApplication.shared.openURL(URL(string: "telprompt://\(customerServicePhone)")!)
                }
            }
        }
    }
}
extension UYUserViewController : UYTableFooterViewDelegate {
    func footButtonAction() {
        if footerView.title == "退出登录" {
            UYAPPManager.shared.logoutAction()
            footerView.title = "登录/注册"
            tableView.reloadData()
//            showWaitToast()
//            request.logoutAction(complete: { [weak self] (error) -> (Void) in
//                if error != nil {
//                    self?.showTextToastAutoDismiss(msg: (error?.description)!)
//                }else{
//                    self?.dismissToast()
//                    self?.footerView.title = "登录/注册"
//                    self?.tableView.reloadData()
//                }
//            })
        }else{
            let loginVC = UYLoginViewController()
            pushToNextVC(nextVC: loginVC)
        }
    }
}
