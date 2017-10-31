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
    fileprivate let tableView = UITableView()
    fileprivate var dataSource = [UYInputModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "添加学历"
        loadLocalData()
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
        
        let footView = UYTableFooterView(title: "添加")
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
    
}

// MARK: - footViewDelegate
extension UYAddDegreeViewController :UYTableFooterViewDelegate {
    func footButtonAction() {
        pushToNextVC(nextVC: UYDegreeListViewController())
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
        let degree = UYInputModel(title: "学历", content: "", placeholder: "请选择您的学历", textFieldEnable: false)
        let occupation = UYInputModel(title: "学校名称", content: "", placeholder: "请输入您的学校名称")
        let monthlyIncome = UYInputModel(title: "学校地址", content: "", placeholder: "请输入学校地址")
        let house = UYInputModel(title: "专业", content: "", placeholder: "请输入你您的专业名称")
        let address = UYInputModel(title: "入学时间", content: "", placeholder: "请输入您的入学时间", textFieldEnable: false)
        let graduation = UYInputModel(title: "毕业时间", content: "", placeholder: "请选择您的毕业时间", textFieldEnable: false)

        dataSource.append(degree)
        dataSource.append(occupation)
        dataSource.append(monthlyIncome)
        dataSource.append(house)
        dataSource.append(address)
        dataSource.append(graduation)
        tableView.reloadData()
    }
}

// MARK: - 网络请求
extension UYAddDegreeViewController {}
