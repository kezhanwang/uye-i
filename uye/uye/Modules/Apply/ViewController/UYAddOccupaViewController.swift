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

    fileprivate let tableView = UITableView()
    fileprivate var dataSource = [UYInputModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "添加职业"
        loadLocalData()
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
            make.left.right.bottom.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        tableView.register(UINib(nibName: "UYInputTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let footView = UYTableFooterView(title: "添加")
        footView.delegate = self
        tableView.tableFooterView = footView
        
        
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
    
}

// MARK: - footViewDelegate
extension UYAddOccupaViewController :UYTableFooterViewDelegate {
    func footButtonAction() {
        pushToNextVC(nextVC: UYOccupaListViewController())
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
        let degree = UYInputModel(title: "单位名称", content: "", placeholder: "请输入您的单位名称")
        let occupation = UYInputModel(title: "入职时间", content: "", placeholder: "请选择您的入职时间", textFieldEnable: false)
        let monthlyIncome = UYInputModel(title: "月收入", content: "", placeholder: "请选择您的离职时间", textFieldEnable: false)
        let house = UYInputModel(title: "职位", content: "", placeholder: "请选择您的职位", textFieldEnable: false)
        let address = UYInputModel(title: "薪资", content: "", placeholder: "请选择您的薪资范围", textFieldEnable: false)
        dataSource.append(degree)
        dataSource.append(occupation)
        dataSource.append(monthlyIncome)
        dataSource.append(house)
        dataSource.append(address)
        tableView.reloadData()
    }
}

// MARK: - 网络请求
extension UYAddOccupaViewController {}
