//
//  UYAddOccupaViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/31.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let cellIdentifier = "cellIdentifier"

class UYAddOccupaViewController: UYBaseViewController {

    var occupaInfo:UYUserElistInfo?
    var fromOccupaList = false
    
    fileprivate var occupaConfig:UYUserElistConfig?
    
    fileprivate let tableView = UITableView()
    fileprivate var dataSource = [UYInputModel]()
    fileprivate let datePicker = KZDatePickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "添加职业"
        loadLocalData()
        getOccupaConifg()
    }
    override func setupUI() {
        setupTabelView()
    }

}

// MARK: - 页面设置
extension UYAddOccupaViewController {
    func setupTabelView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.equalTo(0)
        }
       
        
//        let footView = UYTableFooterView(title: "提交")
//        footView.delegate = self
        tableView.tableFooterView = UIView()
        let bottomView = UYBottomBtnView(title: "提交")
        bottomView.delegate = self
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(kTabBarHeight)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        tableView.register(UINib(nibName: "UYInputTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
}

// MARK: - tableView代理
extension UYAddOccupaViewController :UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UYInputTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.inputModel = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {//入职日期
            let years70:TimeInterval = 24*60*60*365*70
            let minDate = Date(timeIntervalSinceNow: -years70)
            showDatePicer(maxDate: Date(), minDate: minDate, indexPath: indexPath)
            
        }else if indexPath.row == 2 {//离职日期
            let years70:TimeInterval = 24*60*60*365*70
            let minDate = Date(timeIntervalSinceNow: -years70)
            showDatePicer(maxDate: Date(), minDate: minDate, indexPath: indexPath)

        }else if indexPath.row == 3 {//职位
            let dataArray = occupaConfig?.position ?? []
            showDataPicker(dataArray: dataArray, indexPath: indexPath)
        }else if indexPath.row == 4 {//薪资范围
            let dataArray = occupaConfig?.monthly_income ?? []
            showDataPicker(dataArray: dataArray, indexPath: indexPath)
        }
    }
    
}

// MARK: - footViewDelegate
extension UYAddOccupaViewController :UYTableFooterViewDelegate {
    func footButtonAction() {
        submitUserOccupaInfo()
        
    }
    func gotoOccupaList() {
        if fromOccupaList {
            popBackAction()
        }else{
            pushToNextVC(nextVC: UYOccupaListViewController())
            let count = (navigationController?.viewControllers.count)! - 2
            navigationController?.viewControllers.remove(at: count)
        }
    }
}
extension UYAddOccupaViewController :UYInputTableViewCellDelegate {
    func textFieldTextDidChange(indexPath: IndexPath, text: String) {
        var inputModel :UYInputModel = dataSource[indexPath.row]
        inputModel.content = text
        dataSource[indexPath.row] = inputModel
    }
}
// MARK: - 本地数据
extension UYAddOccupaViewController {
    func loadLocalData() {
        dataSource.removeAll()
        let work_name = UYInputModel(title: "单位名称", content: occupaInfo?.work_name ?? "", placeholder: "请输入您的单位名称")
        let date_start = UYInputModel(title: "入职时间", content: occupaInfo?.date_start ?? "", placeholder: "请选择您的入职时间", textFieldEnable: false)
        let date_end = UYInputModel(title: "离职时间", content: occupaInfo?.date_end ?? "", placeholder: "请选择您的离职时间", textFieldEnable: false)
        let work_position = UYInputModel(title: "职位", content: occupaInfo?.work_position ?? "", placeholder: "请选择您的职位", textFieldEnable: false)
        let work_salary = UYInputModel(title: "薪资", content: occupaInfo?.work_salary ?? "", placeholder: "请选择您的薪资范围", textFieldEnable: false)
        dataSource.append(work_name)
        dataSource.append(date_start)
        dataSource.append(date_end)
        dataSource.append(work_position)
        dataSource.append(work_salary)
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
    
    func showDatePicer(maxDate:Date,minDate:Date,indexPath:IndexPath) {
        self.view.endEditing(false)
        var inputModel :UYInputModel = dataSource[indexPath.row]
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        if inputModel.content.isEmpty == false {
            let nowDate = NSDate(from: inputModel.content)! as Date
            
            if (nowDate < minDate  || nowDate > maxDate) {
                datePicker.beginDate = minDate
            }else{
                datePicker.beginDate = nowDate
            }
        }
        datePicker.showDatePickerComolete {[weak self] (date) in
            inputModel.content = date ?? ""
            self?.dataSource[indexPath.row] = inputModel
            self?.tableView.reloadData()
        }
    }
}

// MARK: - 网络请求
extension UYAddOccupaViewController {
    func getOccupaConifg() {
        showWaitToast()
        request.getUserElistConfig { (config, error) in
            if error != nil {
                self.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self.dismissToast()
                self.occupaConfig = config
            }
        }
    }
    func checkParameters() -> Bool {
        for inputModel in dataSource {
            guard inputModel.content.characters.count > 0 else {
                showTextToastAutoDismiss(msg: inputModel.placeholder)
                return false
            }
        }
        return true
    }
    func loadParameters() -> [String:Any] {
        let work_name :UYInputModel = dataSource[0]
        let date_start :UYInputModel = dataSource[1]
        let date_end :UYInputModel = dataSource[2]
        let work_position :UYInputModel = dataSource[3]
        let work_salary :UYInputModel = dataSource[4]
        let id:String = occupaInfo?.id ?? ""
        
        return ["id":id,
                "work_name":work_name.content,
                "work_position":work_position.content,
                "work_salary":work_salary.content,
                "date_start":date_start.content,
                "date_end":date_end.content,
                "type":"2",
        ]
    }
    func submitUserOccupaInfo() {
        guard checkParameters() else {
            return
        }
        let parameters = loadParameters()
        showWaitToast()
        request.submitUserElistInfo(parameters: parameters) { (error) -> (Void) in
            if error != nil {
                self.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self.dismissToast()
                self.gotoOccupaList()
            }
        }
        
    }
    
}
