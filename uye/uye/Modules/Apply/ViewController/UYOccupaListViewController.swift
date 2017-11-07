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

    var isDegreeList = false
    
    fileprivate let tableView = UITableView()
    fileprivate var dataSourece = [UYUserElistInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isDegreeList {
            navigationItem.title = "个人经历-学历"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加学历", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addElistAcion))
        }else{
            navigationItem.title = "个人经历-职业"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加职业", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addElistAcion))
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getOccupaList()
    }
    override func setupUI() {
        setupTableView()
    }
}

extension UYOccupaListViewController {
    @objc func addElistAcion() {
        
        if isDegreeList {
            pushToNextVC(nextVC: UYAddDegreeViewController())
        }else{
            let occupaVC = UYAddOccupaViewController()
            occupaVC.fromOccupaList = true
            pushToNextVC(nextVC: occupaVC)
        }
        
    }
}
extension UYOccupaListViewController {
    func setupTableView()  {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.register(UINib(nibName: "UYElistTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView.tableFooterView = UIView()
        let bottomView = UYBottomBtnView(title: "下一步")
        bottomView.delegate = self
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(kTabBarHeight)
        }
    }
    
}

extension UYOccupaListViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourece.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UYElistTableViewCell
        let listInfo = dataSourece[indexPath.row]
        cell.dateLabel?.text = "\(listInfo.date_start ?? "")~\(listInfo.date_end ?? "")"
        if isDegreeList {
            cell.nameLabel.text = listInfo.school_name
        }else{
            cell.nameLabel.text = listInfo.work_name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let listInfo = dataSourece[indexPath.row]
        if isDegreeList {
            let degreeVC = UYAddDegreeViewController()
            degreeVC.fromDegreeList = true
            degreeVC.degreeInfo = listInfo
            pushToNextVC(nextVC: degreeVC)
        }else{
            let occupaVC = UYAddOccupaViewController()
            occupaVC.occupaInfo = listInfo
            occupaVC.fromOccupaList = true
            pushToNextVC(nextVC: occupaVC)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let listInfo = dataSourece[indexPath.row]
            deleteUserElistInfo(listId: listInfo.id!,index: indexPath)
        }
    }
}

//下一步按钮点击
extension UYOccupaListViewController :UYTableFooterViewDelegate {
    func footButtonAction() {
        if isDegreeList {
            
            popToViewController(targetVC: UYUserInfoViewController.self)
        }else{
            request.getUserElistInfo(type: 1, complete: { (list, error) in
                if error != nil {
                    showTextToast(msg: (error?.description)!)
                }else{
                    if list?.count ?? 0 > 0 {
                        let degressListVC = UYOccupaListViewController()
                        degressListVC.isDegreeList = true
                        self.pushToNextVC(nextVC: degressListVC)
                        
                    }else{
                        self.pushToNextVC(nextVC: UYAddDegreeViewController())
                    }
                }
            })
            

        }
    }
}

// MARK: - 网络请求
extension UYOccupaListViewController {
    func getOccupaList()  {
        let type : Int = isDegreeList == true ? 1 : 2
        request.getUserElistInfo(type: type) { (infoList, error) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                self.dataSourece.removeAll()
                self.dataSourece += infoList!
                self.tableView.reloadData()
            }
        }
    }
    func deleteUserElistInfo(listId:String,index:IndexPath) {
        showWaitToast()
        request.deleteUserElist(elistId: listId) { (error) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                self.dataSourece.remove(at: index.row)
                self.tableView.deleteRows(at: [index], with: .fade)
            }
        }
    }
}


