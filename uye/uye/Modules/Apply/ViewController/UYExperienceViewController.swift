//
//  UYExperienceViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/30.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let cellIdentifier = "cellIdentifier"
fileprivate let tagCellIdentifier = "UYAreaTableViewCellIdentifier"
class UYExperienceViewController: UYBaseViewController {

    fileprivate let tableView:UITableView = UITableView()
    fileprivate var dataSource = [UYInputModel]()
    fileprivate var experConfig : UYUserExperConfig?
    fileprivate var experInfo = UYUserExperInfo()
    fileprivate var areaCellHeight :CGFloat = 50
    fileprivate let addressPicker = UYAddressPicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人经历-基本信息"
        loadLocalData()
        getExperConfig()
        getExperInfo()
    }
    override func setupUI() {
        setupTableView()
    }
}

// MARK: - 页面设置
extension UYExperienceViewController {
    func setupTableView()  {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.bottom.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "UYInputTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UYAreaTableViewCell.classForCoder(), forCellReuseIdentifier: tagCellIdentifier)
        let footView = UYTableFooterView(title: "下一步")
        footView.delegate = self
        tableView.tableFooterView = footView
        
    }
}

// MARK: - UITableViewDelegate、dataSource
extension UYExperienceViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: tagCellIdentifier, for: indexPath) as! UYAreaTableViewCell
            cell.delegate = self
            cell.areaArray = experInfo.will_work_city
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UYInputTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.inputModel = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 4 {
            return areaCellHeight
        }
        return 46
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row < 4 else { return }
        var dataArray :[String] = []

        if indexPath.row == 0 {
            dataArray = experConfig?.highest_education ?? []
        }else if indexPath.row == 1 {
            dataArray = experConfig?.profession ?? []
        }else if indexPath.row == 2 {
            dataArray = experConfig?.housing_situation ?? []
        }else if indexPath.row == 3 {
            dataArray = experConfig?.monthly_income ?? []
        }
        showDataPicker(dataArray: dataArray, indexPath: indexPath)
    }
}

// MARK: - 就地地区的增加与删除
extension UYExperienceViewController :UYAreaTableViewCellDelegate {
    
    func areaCellAddTagAction() {
        addressPicker.showArea = false
        addressPicker.showAddressPicker({[weak self] (province, city, area) -> (Void) in
             var name = city?.name
            if city?.name == "县" || city?.name == "市辖区" || city?.name == "市" {
                name = province?.name
            }
            DispatchQueue.main.async {
                if self?.experInfo.will_work_city.contains(name!) == false {
                    self?.experInfo.will_work_city.append(name!)
                    self?.tableView.reloadRows(at:[IndexPath(row: 4, section: 0)], with: UITableViewRowAnimation.automatic)
                }
            }
        })
    }
    func areaCellDeleteTagAction(area: String) {
        let index :Int = experInfo.will_work_city.index(of: area) ?? 0
        experInfo.will_work_city.remove(at: index)
        tableView.reloadRows(at:[IndexPath(row: 4, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    func areaCellHeightChanged(height: CGFloat) {
        areaCellHeight = height
        tableView.reloadRows(at:[IndexPath(row: 4, section: 0)], with: UITableViewRowAnimation.none)
    }
}
// MARK: - 本地数据处理
extension UYExperienceViewController {
    func loadLocalData() {
        dataSource.removeAll()
        let degree = UYInputModel(title: "最高学历", content: self.experInfo.highest_education ?? "", placeholder: "请选择您的学历", textFieldEnable: false)
        let occupation = UYInputModel(title: "职业", content:  self.experInfo.profession ?? "", placeholder: "请选择您的职业", textFieldEnable: false)
        let monthlyIncome = UYInputModel(title: "月收入", content: self.experInfo.monthly_income ?? "", placeholder: "请选择您的月收入", textFieldEnable: false)
        let house = UYInputModel(title: "住房情况", content: self.experInfo.housing_situation ?? "", placeholder: "请选择您的住房情况", textFieldEnable: false)
        let address = UYInputModel(title: "就业地区", content: "", placeholder: "请添加您期望的工作地区", textFieldEnable: false)
        
        dataSource.append(degree)
        dataSource.append(occupation)
        dataSource.append(monthlyIncome)
        dataSource.append(house)
        dataSource.append(address)
        tableView.reloadData()
    }

    func showDataPicker(dataArray:[String],indexPath:IndexPath) {
        var inputModel = dataSource[indexPath.row]
        
        let dataPicker = KZDataPicker(mutableComponent: false, dataArray: dataArray)
        dataPicker?.selectIndex = UInt(dataArray.index(of: inputModel.content) ?? 0)
        dataPicker?.showSinglePicker(pickerSelect: {[weak self] (result, isFinal) in
            if isFinal {
                inputModel.content = result ?? ""
                self?.dataSource[indexPath.row] = inputModel
                self?.tableView.reloadData()
            }
        })
    }
}
// MARK: - 网络请求
extension UYExperienceViewController {
    func getExperConfig() {
        showWaitToast()
        request.getUserExperConfig { (config, error) in
            if error != nil {
                self.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self.dismissToast()
                self.experConfig = config
            }
        }
    }
    func getExperInfo()  {
        showWaitToast()
        request.getUserExperInfo { (info, error) in
            if error != nil {
                self.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self.dismissToast()
                self.experInfo = info!
                self.loadLocalData()
                
            }
            
        }
    }
    func checkParameters() -> Bool {
        
        for inputModel in dataSource {
            if inputModel.title != "就业地区" {
                guard inputModel.content.characters.count > 0 else {
                    showTextToastAutoDismiss(msg: inputModel.placeholder)
                    return false
                }
            }
        }
        if experInfo.will_work_city.count == 0 {
            showTextToastAutoDismiss(msg: "请添加您期望的工作地区")
            return false
        }
        return true
    }
    func loadParameters() -> [String:Any] {
        let highest_education :UYInputModel = dataSource[0]
        let profession :UYInputModel = dataSource[1]
        let housing_situation :UYInputModel = dataSource[2]
        let monthly_income :UYInputModel = dataSource[3]
        
        var workCity = ""
        
        if let data = try? JSONSerialization.data(withJSONObject: experInfo.will_work_city, options: JSONSerialization.WritingOptions.prettyPrinted) {
            workCity = String(data: data, encoding: String.Encoding.utf8) ?? ""
        }
        return ["highest_education":highest_education.content,
                "profession":profession.content,
                "housing_situation":housing_situation.content,
                "monthly_income":monthly_income.content,
                "will_work_city":workCity,
        ]
    }
    func submitExperInfo() {
        guard checkParameters() else {
            return
        }
        let parameters = loadParameters()
        showWaitToast()
        request.submitUserExperInfo(parameters: parameters) { (error) -> (Void) in
            if error != nil {
                self.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self.dismissToast()
                self.gotoNextViewController()
            }
        }
    }
}

// MARK: - footViewDelegate
extension UYExperienceViewController:UYTableFooterViewDelegate {
    func footButtonAction() {
        submitExperInfo()
    }
    func gotoNextViewController() {
        let profession :UYInputModel = dataSource[1]
        if profession.content == "未就业" {
            pushToNextVC(nextVC: UYAddDegreeViewController())
        }else{
            pushToNextVC(nextVC: UYAddOccupaViewController())
        }

    }
}

extension UYExperienceViewController : UYInputTableViewCellDelegate {
    func textFieldTextDidChange(indexPath: IndexPath, text: String) {
        var inputModel :UYInputModel = dataSource[indexPath.row]
        inputModel.content = text
        dataSource[indexPath.row] = inputModel
    }
}
