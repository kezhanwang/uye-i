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
    fileprivate let addressPicker = UYAddressPicker()
    fileprivate var contactConfig:UYContactConfig?
    fileprivate var dataPicker :KZDataPicker! = nil
    fileprivate var contactInfo = UYUserContactInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "联系人信息"
    }
    override func setupUI() {
        getContactInfo()
        loadLoaclDatas()
        setupTableView()
        getContactConfig()
        
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
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 0.1))
        let footView = UYTableFooterView(title: "完成")
        footView.delegate  = self
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
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.blackText
        if section == 0 {
            titleLabel.text = "个人信息"
        }else{
            titleLabel.text = "紧急联系人"
        }
        return headView
        //999999
        //c0c0c0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (indexPath.section == 0 && indexPath.row == 0) ||
//            (indexPath.section == 0 && indexPath.row == 5 ){
//            cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0)
//            cell.layoutMargins = UIEdgeInsetsMake(0, kScreenWidth, 0, 0)
//        }
        if indexPath.section == 0 && indexPath.row == 3 {
            cell.separatorInset = UIEdgeInsetsMake(0, 90, 0, 0)
            cell.layoutMargins = UIEdgeInsetsMake(0, 90, 0, 0)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(false)
        if indexPath.section == 0 {
            if indexPath.row == 0 {//婚姻状态选择
                if contactConfig != nil {
                    var marriageModel = dataSource[indexPath.section][indexPath.row]
                    
                    dataPicker = KZDataPicker(mutableComponent: false, dataArray: contactConfig?.marriage!)
                    dataPicker.selectIndex = UInt(contactConfig?.marriage?.index(of: marriageModel.content) ?? 0)
                    dataPicker.showSinglePicker(pickerSelect: {[weak self] (result, isFinal) in
                        if isFinal {
                            marriageModel.content = result ?? ""
                            self?.dataSource[indexPath.section][indexPath.row] = marriageModel
                            self?.tableView.reloadData()
                        }
                    })
                }else{
                    showTextToast(msg: "婚姻状况获取失败，请返回上个页面，重新获取")
                }
            }else if indexPath.row == 3 {//地址选择
                var addressModel = dataSource[indexPath.section][indexPath.row]
                addressPicker.showAddressPicker({[weak self] (province, city, area) -> (Void) in
                    addressModel.content = area?.joinname ?? ""
                    self?.contactInfo.home_province = Int((province?.id)!)!
                    self?.contactInfo.home_city = Int((city?.id)!)!
                    self?.contactInfo.home_area = Int((area?.id)!)!
                    self?.dataSource[indexPath.section][indexPath.row] = addressModel
                    self?.tableView.reloadData()
                })
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 { //关系选择
                if contactConfig != nil {
                    var marriageModel = dataSource[indexPath.section][indexPath.row]
                    
                    dataPicker = KZDataPicker(mutableComponent: false, dataArray: contactConfig?.relation!)
                    dataPicker.selectIndex = UInt(contactConfig?.relation?.index(of: marriageModel.content) ?? 0)
                    dataPicker.showSinglePicker(pickerSelect: {[weak self] (result, isFinal) in
                        if isFinal {
                            marriageModel.content = result ?? ""
                            self?.dataSource[indexPath.section][indexPath.row] = marriageModel
                            self?.tableView.reloadData()
                        }
                    })
                }else{
                    showTextToast(msg: "关系列表获取失败，请返回上个页面，重新获取")
                }
            }
        }
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
        dataSource.removeAll()
        let marriage = UYInputModel(title: "婚姻状况", content: contactInfo.marriage, placeholder: "请选择婚姻状况", textFieldEnable: false)
        let email = UYInputModel(title: "电子邮箱", content: contactInfo.email, placeholder: "请填写电子邮箱",  keyboardType: UIKeyboardType.emailAddress)
        let wchat = UYInputModel(title: "微信", content: contactInfo.wechat, placeholder: "请填写微信号")
        
        let addressProvinces = UYInputModel(title: "住址",content:contactInfo.home, placeholder: "请选择住址省市",textFieldEnable: false)
        let addressDetail =  UYInputModel(title: "",content:contactInfo.home_address, placeholder: "请填写详细地址")
        
        let qq = UYInputModel(title: "QQ", content: contactInfo.qq, placeholder: "请输入QQ号", keyboardType: UIKeyboardType.numberPad)
        
        let relation = UYInputModel(title: "与本人关系", content: contactInfo.contact1_relation, placeholder: "请选择与联系人的关系", textFieldEnable: false)
        let name = UYInputModel(title: "姓名", content: contactInfo.contact1_name, placeholder: "请填写紧急联系人姓名")
        let phone = UYInputModel(title: "手机号码", content: contactInfo.contact1_phone, placeholder: "请填写联系人手机号码",  keyboardType: UIKeyboardType.numberPad)

        dataSource.append([marriage,email,wchat,addressProvinces,addressDetail,qq])
        dataSource.append([relation,name,phone])
        tableView.reloadData()
        
    }
}

// MARK: - 网络请求
extension UYContactsViewController {
    func getContactConfig() {
        showWaitToast()
        request.getUserContactConfig {[weak self] (config, error) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                self?.contactConfig = config
            }
        }
    }
    func getContactInfo() {
        showWaitToast()
        request.getUserContactInfo {[weak self] (contactInfo, error) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                self?.contactInfo = contactInfo!
                self?.loadLoaclDatas()
            }
        }
    }
    func checkParameters() -> Bool {
        for inputModelArray in dataSource {
            for inputModel in inputModelArray {
                guard inputModel.content.count > 0 else {
                    showTextToast(msg: inputModel.placeholder)
                    return false
                }
            }
        }
        return true
    }
    func loadParameters() -> [String:Any] {
        let marriage :UYInputModel = dataSource[0][0]
        let email :UYInputModel = dataSource[0][1]
        let weChat :UYInputModel = dataSource[0][2]
//        let endModel :UYInputModel = dataSource[0][3]
        let addressModel :UYInputModel = dataSource[0][4]
        let qq :UYInputModel = dataSource[0][5]
        let relation :UYInputModel = dataSource[1][0]
        let name :UYInputModel = dataSource[1][1]
        let phoneModel :UYInputModel = dataSource[1][2]
    
        
        return ["home_province":contactInfo.home_province,
                "home_city":contactInfo.home_city,
                "home_area":contactInfo.home_area,
                "home_address":addressModel.content,
                "email":email.content,
                "wechat":weChat.content,
                "qq":qq.content,
                "marriage":marriage.content,
                "contact1_name":name.content,
                "contact1_phone":phoneModel.content,
                "contact1_relation":relation.content,
        ]
    }
    func submitContactInfo() {
        guard checkParameters() else {
            return
        }
        let parameters = loadParameters()
        showWaitToast()
        request.submitUserContactInfo(parameters: parameters) {[weak self] (error) -> (Void) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                self?.popBackAction()
            }
        }
    }
}

extension UYContactsViewController : UYTableFooterViewDelegate {
    func footButtonAction() {
        submitContactInfo()
    }
}
