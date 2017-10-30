//
//  UYContactsViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/30.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let cellIdentifier = "inputCellIdentifier"
class UYContactsViewController: UYBaseViewController {

    fileprivate let tableView :UITableView = UITableView(frame: .zero, style: .grouped)
    fileprivate var dataSource = [[UYInputModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "联系人信息"
    }
    override func setupUI() {
        loadLoaclDatas()
        setupTableView()
    }
}

// MARK: - 设置页面
extension UYContactsViewController {
    func setupTableView() {
        view.addSubview(tableView);
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.bottom.equalTo(0)
        }
//        tableView.sep
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UYInputTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        let footView = UYTableFooterView(title: "完成")
        tableView.tableFooterView = footView
        
    }
}

// MARK: - 设置tableViewdelegate,dateSourece
extension UYContactsViewController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UYInputTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.inputModel = dataSource[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 45))
        headView.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        headView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.blackText
        if section == 0 {
            titleLabel.text = "个人信息"
        }else{
            titleLabel.text = "紧急联系人"
        }
        return headView
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsetsMake(0, 90, 0, 0)
            cell.layoutMargins = UIEdgeInsetsMake(0, 90, 0, 0)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

// MARK: - UYInputTableViewCellDelegate
extension UYContactsViewController : UYInputTableViewCellDelegate {
    func textFieldTextDidChange(indexPath: IndexPath, text: String) {
        var inputModel :UYInputModel = dataSource[indexPath.section][indexPath.row]
        inputModel.content = text
        dataSource[indexPath.section][indexPath.row] = inputModel
    }
}
// MARK: - 本地数据处理
extension UYContactsViewController {
    func loadLoaclDatas() {
        let addressProvinces = UYInputModel(title: "住址",content:"", placeholder: "请选择住址省市",textFieldEnable: false)
        let addressDetail =  UYInputModel(title: "",content:"", placeholder: "请填写详细地址")
        let marriage = UYInputModel(title: "婚姻状况", content: "", placeholder: "请选择婚姻状况", textFieldEnable: false)
        let email = UYInputModel(title: "电子邮箱", content: "", placeholder: "请填写电子邮箱",  keyboardType: UIKeyboardType.emailAddress)
        let wchat = UYInputModel(title: "微信", content: "", placeholder: "请填写微信号")
        let qq = UYInputModel(title: "QQ", content: "", placeholder: "请输入QQ号", keyboardType: UIKeyboardType.numberPad)
        
        let relation = UYInputModel(title: "与本人关系", content: "", placeholder: "请选择与联系人的关系", textFieldEnable: false)
        let name = UYInputModel(title: "姓名", content: "", placeholder: "请填写紧急联系人姓名")
        let phone = UYInputModel(title: "手机号码", content: "", placeholder: "请填写联系人手机号码",  keyboardType: UIKeyboardType.numberPad)

        dataSource.append([addressProvinces,addressDetail,marriage,email,wchat,qq])
        dataSource.append([relation,name,phone])
        
    }
}

// MARK: - 网络请求
extension UYContactsViewController {
   
}

extension UYContactsViewController {
    
}
