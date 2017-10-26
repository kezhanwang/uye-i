//
//  UYOrganiseDetailViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/17.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let organiseInfoCellIdentifier = "organiseCellIdentifier"
fileprivate let addressCellIdentifier = "addressCellIdentifier"
fileprivate let courseCellIdentifier = "courseCellIdentifeir"
fileprivate let headViewIdentifier = "headViewIdentifier"
fileprivate let introduceIdentifier = "introduceIdentifier"

class UYOrganiseDetailViewController: UYBaseViewController {
    
    var organise:UYOrganiseModel?
    fileprivate var organiseDetailInfo:UYOrganiseDetailModel?
    fileprivate let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = organise?.org_name
        loadOrganiseDetailData()
    }
    override func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-49)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UYOrganiseInfoCell", bundle: nil), forCellReuseIdentifier: organiseInfoCellIdentifier)
        tableView.register(UINib(nibName: "UYCustomSimpleTableCell", bundle: nil), forCellReuseIdentifier: addressCellIdentifier)
        tableView.register(UINib(nibName: "UYCourseTableViewCell", bundle: nil), forCellReuseIdentifier: courseCellIdentifier)
        tableView.register(UYOrganiseIntroduceTableViewCell.classForCoder(), forCellReuseIdentifier: introduceIdentifier)
        
    }


}
extension UYOrganiseDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSection = 2
        if organiseDetailInfo?.courses!.count ?? 0 > 0 {
            numberOfSection = numberOfSection + 1
        }
        return numberOfSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        if section == 1 {
            if let count = organiseDetailInfo?.courses?.count {
                let numberRow = Int(ceil(Double(count)/2))
                return numberRow
            }else{
                return 0
            }
            
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0  {
            if indexPath.row == 0 {
                let cell  = tableView.dequeueReusableCell(withIdentifier: organiseInfoCellIdentifier, for: indexPath) as! UYOrganiseInfoCell
                cell.organiseInfo = organiseDetailInfo?.organize
                return cell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: addressCellIdentifier, for: indexPath) as! UYCustomSimpleTableCell
                cell.iconView.image = #imageLiteral(resourceName: "organise_address_icon")
                cell.nameLabel.text = organiseDetailInfo?.organize?.address
                return cell
                
            }
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: courseCellIdentifier, for: indexPath) as! UYCourseTableViewCell
            var index = indexPath.row * 2
            
            cell.courseInfo1 = organiseDetailInfo?.courses![index]
            if let count = organiseDetailInfo?.courses?.count {
                index = index + 1
                i.cxc cx 10f count > index  {
                    cell.courseInfo2 = organiseDetailInfo?.courses![index]
                }else{
                    cell.courseInfo2 = nil
                }
            }
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier:introduceIdentifier , for: indexPath) as! UYOrganiseIntroduceTableViewCell
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 110
            }
            if indexPath.row == 1 {
                return 44
            }
        }else if indexPath.section == 1 {
            if let count = organiseDetailInfo?.courses?.count {
                if count > 0 {
                    return 150
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }else if indexPath.section == 2 {
            return 111
        }
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - 网络请求
extension UYOrganiseDetailViewController {
    func loadOrganiseDetailData() {
        showWaitToast()
        request.getOrganiseDetail(orgId: organise?.org_id ?? "") {[weak self] (organiseModel, error) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                self?.organiseDetailInfo = organiseModel
                self?.tableView.reloadData()
            }
        }
    }
}






