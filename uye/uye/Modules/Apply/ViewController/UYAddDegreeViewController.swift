//
//  UYAddDegreeViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/31.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let cellIdentifier = "cellIdentifier"
class UYAddDegreeViewController: UYBaseViewController {
    
    var degreeInfo:UYUserElistInfo?
    var fromDegreeList = false
    
    fileprivate var degreeConfig:UYUserElistConfig?
    fileprivate let tableView = UITableView()
    fileprivate var dataSource = [UYInputModel]()
    fileprivate let datePicker = KZDatePickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "添加学历"
        loadLocalData()
        getDegreeConifg()
    }

    override func setupUI() {
        setupTabelView()
    }

}

// MARK: - 页面设置
extension UYAddDegreeViewController {
    func setupTabelView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.bottom.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        tableView.register(UINib(nibName: "UYInputTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let footView = UYTableFooterView(title: "提交")
        footView.delegate = self
        tableView.tableFooterView = footView
        
        
    }
}

// MARK: - tableView代理
extension UYAddDegreeViewController :UITableViewDataSource,UITableViewDelegate {
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
        if indexPath.row == 0 {
            let dataArray = degreeConfig?.education ?? []
            showDataPicker(dataArray: dataArray, indexPath: indexPath)
        }else if indexPath.row == 4 || indexPath.row == 5 {
            let years70:TimeInterval = 24*60*60*365*70
            let minDate = Date(timeIntervalSinceNow: -years70)
            showDatePicer(maxDate: Date(), minDate: minDate, indexPath: indexPath)
        }
    }
}

// MARK: - footViewDelegate
extension UYAddDegreeViewController :UYTableFooterViewDelegate {
    func footButtonAction() {
        submitUserDegreeInfo()
    }
    func gotoDegreeListVC() {
        if fromDegreeList {
            popBackAction()
        }else{
            let degreeVC = UYOccupaListViewController()
            degreeVC.isDegreeList = true
            pushToNextVC(nextVC: degreeVC)
            
            let count = (navigationController?.viewControllers.count)! - 2
            navigationController?.viewControllers.remove(at: count)
        }
    }
    
    
}
extension UYAddDegreeViewController :UYInputTableViewCellDelegate {
    func textFieldTextDidChange(indexPath: IndexPath, text: String) {
        var inputModel :UYInputModel = dataSource[indexPath.row]
        inputModel.content = text
        dataSource[indexPath.row] = inputModel
    }
}
// MARK: - 本地数据
extension UYAddDegreeViewController {
    func loadLocalData() {
        dataSource.removeAll()
        let degree = UYInputModel(title: "学历", content: degreeInfo?.education ?? "", placeholder: "请选择您的学历", textFieldEnable: false)
        let schoolName = UYInputModel(title: "学校名称", content: degreeInfo?.school_name ?? "", placeholder: "请输入您的学校名称")
        let address = UYInputModel(title: "学校地址", content: degreeInfo?.school_address ?? "", placeholder: "请输入学校地址")
        let school_profession = UYInputModel(title: "专业", content: degreeInfo?.school_profession ?? "", placeholder: "请输入你您的专业名称")
        let date_start = UYInputModel(title: "入学时间", content: degreeInfo?.date_start ?? "", placeholder: "请输入您的入学时间", textFieldEnable: false)
        let date_end = UYInputModel(title: "毕业时间", content: degreeInfo?.date_end ?? "", placeholder: "请选择您的毕业时间", textFieldEnable: false)

        dataSource.append(degree)
        dataSource.append(schoolName)
        dataSource.append(address)
        dataSource.append(school_profession)
        dataSource.append(date_start)
        dataSource.append(date_end)
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
extension UYAddDegreeViewController {
    func getDegreeConifg() {
        showWaitToast()
        request.getUserElistConfig { (config, error) in
            if error != nil {
                self.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self.dismissToast()
                self.degreeConfig = config
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
        let education :UYInputModel = dataSource[0]
        let school_name :UYInputModel = dataSource[1]
        let school_address :UYInputModel = dataSource[2]
        let school_profession :UYInputModel = dataSource[3]
        let date_start :UYInputModel = dataSource[4]
        let date_end :UYInputModel = dataSource[5]

        let id:String = degreeInfo?.id ?? ""
        
        return ["id":id,
                "education":education.content,
                "school_name":school_name.content,
                "school_address":school_address.content,
                "school_profession":school_profession.content,
                "date_start":date_start.content,
                "date_end":date_end.content,
                "type":"1",
                ]
    }
    func submitUserDegreeInfo() {
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
                self.gotoDegreeListVC()
            }
        }
        
    }
}
