//
//  UYOccupaListViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/31.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let cellIdentifier = "tableViewcellIdentifier"
class UYOccupaListViewController: UYBaseViewController {

    fileprivate let tableView = UITableView()
    fileprivate var dataSourece = [UYInputModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人经历-职业"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加职业", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addOccupaAcion))
    }
    override func setupUI() {
        setupTableView()
    }



}

extension UYOccupaListViewController {
    @objc func addOccupaAcion() {
        pushToNextVC(nextVC: UYAddOccupaViewController())
    }
}
extension UYOccupaListViewController {
    func setupTableView()  {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.bottom.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        
        let footView = UYTableFooterView(title: "下一步")
        footView.delegate = self
        tableView.tableFooterView = footView

        
    }
    
}

extension UYOccupaListViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension UYOccupaListViewController :UYTableFooterViewDelegate {
    func footButtonAction() {
        pushToNextVC(nextVC: UYAddDegreeViewController())
    }
}
extension UYOccupaListViewController {
    func loadLocalData() {
        dataSourece.removeAll()
    }
}
extension UYOccupaListViewController {
    func getOccupaList()  {
        
    }
}
extension UYOccupaListViewController {}
extension UYOccupaListViewController {}

