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
fileprivate let moreCourseCellIdentifier = "moreCellIdentifier"
fileprivate let headViewIdentifier = "headViewIdentifier"
fileprivate let introduceIdentifier = "introduceIdentifier"
class UYOrganiseDetailViewController: UYBaseViewController {
    var isShowMore = false
    
    var organise:UYOrganiseModel?
    
    fileprivate var organiseDetailInfo:UYOrganiseDetailModel?
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    
    fileprivate var bottomBar:UYOrganiseBottomBar? = nil
    
    fileprivate var webViewHeight :CGFloat = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = organise?.org_name
        loadOrganiseDetailData()
    }

    override func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "UYOrganiseInfoCell", bundle: nil), forCellReuseIdentifier: organiseInfoCellIdentifier)
        tableView.register(UINib(nibName: "UYCustomSimpleTableCell", bundle: nil), forCellReuseIdentifier: addressCellIdentifier)
        tableView.register(UINib(nibName: "UYCourseTableViewCell", bundle: nil), forCellReuseIdentifier: courseCellIdentifier)
        
        tableView.register(UINib(nibName: "UYMoreCourseTableViewCell", bundle: nil), forCellReuseIdentifier: moreCourseCellIdentifier)
        
        tableView.register(UYOrganiseIntroduceTableViewCell.classForCoder(), forCellReuseIdentifier: introduceIdentifier)
        tableView.register(UINib(nibName: "UYOrganiseDetailHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: headViewIdentifier)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 1))
        
        bottomBar = UYOrganiseBottomBar.loadBottomBar()
        if  bottomBar !=  nil {
            view.addSubview(bottomBar!)
            bottomBar?.snp.makeConstraints({ (make) in
                make.top.equalTo(tableView.snp.bottom).offset(0)
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(kTabBarHeight+6)
            })
            bottomBar?.delegate = self
        }
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
    }

    
   


}
extension UYOrganiseDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        if section == 1 {
            if let count = organiseDetailInfo?.courses?.count {
                let numberRow = Int(ceil(Double(count)/2))
                if isShowMore {
                    return numberRow
                }else{
                    if numberRow > 2 {
                        return 3
                    }else{
                        return numberRow
                    }
                }
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
                cell.delegate = self
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
            if isShowMore == false && indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: moreCourseCellIdentifier, for: indexPath) as! UYMoreCourseTableViewCell
                
                var index = indexPath.row * 2
                cell.courseInfo1 = organiseDetailInfo?.courses![index]
                if let count = organiseDetailInfo?.courses?.count {
                    index = index + 1
                    if count > index  {
                        cell.courseInfo2 = organiseDetailInfo?.courses![index]
                    }else{
                        cell.courseInfo2 = nil
                    }
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: courseCellIdentifier, for: indexPath) as! UYCourseTableViewCell
                
                var index = indexPath.row * 2
                cell.courseInfo1 = organiseDetailInfo?.courses![index]
                if let count = organiseDetailInfo?.courses?.count {
                    index = index + 1
                    if count > index  {
                        cell.courseInfo2 = organiseDetailInfo?.courses![index]
                    }else{
                        cell.courseInfo2 = nil
                    }
                }
                return cell
            }
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier:introduceIdentifier , for: indexPath) as! UYOrganiseIntroduceTableViewCell
            cell.delegate = self
            cell.urlString = organiseIntroduce(orgId: organiseDetailInfo?.organize?.org_id ?? "")
            
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
                    if isShowMore == false && indexPath.row == 2 {
                       return 100
                    }else{
                        return 150
                    }
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }else if indexPath.section == 2 {
            return webViewHeight
        }
        return 44
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            if let count = organiseDetailInfo?.courses?.count {
                if count > 0 {
                    return 10
                }else{
                    return 0.01
                }
            }else{
                return 0.01
            }
        }
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section > 0 {
            if section == 1 {
                if let count = organiseDetailInfo?.courses?.count {
                    if count > 0 {
                        return 50
                    }else{
                        return 0
                    }
                }else{
                    return 0
                }
            }
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section > 0 {
            
            let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headViewIdentifier) as! UYOrganiseDetailHeaderView
            
            headView.contentView.backgroundColor = UIColor.white
            if section == 1 {
                if  let count = organiseDetailInfo?.courses?.count,
                    count > 0 {
                    headView.titleLabel.text = "精彩 • 课程"
                }else{
                    return UIView()
//                    headView.titleLabel.text = ""
                }
            }else{
                headView.titleLabel.text = "课程 • 介绍"
            }
            return headView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {//展示地图
                let mapViewController = UYMapViewController()
                mapViewController.organise = organiseDetailInfo?.organize
                pushToNextVC(nextVC: mapViewController)
                
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 2 && isShowMore == false {
                isShowMore = true
                tableView.reloadData()
            }
        }else if indexPath.section == 2 {
            let webVC  = UYWebViewController()
            webVC.urlString = organiseIntroduce(orgId: organiseDetailInfo?.organize?.org_id ?? "")
            pushToNextVC(nextVC: webVC)
            
        }
    }
}
extension UYOrganiseDetailViewController : UYOrganiseIntroduceTableViewCellDelegate {
    func IntroduceTableViewCellHeightChanged(expectHeight: CGFloat) {
        guard webViewHeight != expectHeight else { return }
        DispatchQueue.main.async {
            self.webViewHeight = expectHeight
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: UITableViewRowAnimation.none)
        }
        
    }
}
extension UYOrganiseDetailViewController :UYOrganiseBottomBarDelegate {
    func callOrganisePhone() {
        if let phoeNumber = organise?.phone {
            if phoeNumber.count > 0 {
                let alertVC = UIAlertController(title: "机构电话", message: nil, preferredStyle: .actionSheet)
                alertVC.addAction(UIAlertAction(title: customerServicePhone, style: .default, handler: { (action) in
                    DispatchQueue.main.async {
                        UIApplication.shared.openURL(URL(string: "telprompt://\(phoeNumber)")!)
                    }
                }))
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                present(alertVC, animated: true, completion: nil)
            }else{
                showTextToast(msg: "暂无机构电话")
            }
        }else{
            showTextToast(msg: "暂无机构电话")
        }
    }
    func collectOrganiseAction() {
        organise?.is_collect = !(organise?.is_collect)!
        if organise?.is_collect == false {
            bottomBar!.collectionImageView.image = #imageLiteral(resourceName: "organise_collect_icon")
        }else{
            bottomBar?.collectionImageView.image = #imageLiteral(resourceName: "organise_uncollect_icon")
        }
    }
    func signOrganiseAction() {
        if UYAPPManager.shared.userInfo != nil {
            
            UYAPPManager.shared.checkOrganiseNeedQuestion(orgId: organise?.org_id ?? "", complete: { () -> (Void) in
                
                if (UYAPPManager.shared.questionListInfo?.need_question)! {
                    let quetionVC = UYQuestionnaireViewController()
                    quetionVC.org_id = self.organise?.org_id ?? ""
                    self.pushToNextVC(nextVC: quetionVC)
                }else{
                    let userInfoVC = UYUserInfoViewController()
                    userInfoVC.order_id = self.organise?.org_id ?? ""
                    self.pushToNextVC(nextVC: userInfoVC)
                }
            })
            
        }else{
            pushToNextVC(nextVC: UYLoginViewController())
        }
    }
}
extension UYOrganiseDetailViewController : UYOrganiseInfoCellDelegate {
    func signOrganiseCellAction() {
        signOrganiseAction()
    }
}
// MARK: - 网络请求
extension UYOrganiseDetailViewController {
    func loadOrganiseDetailData() {
        showWaitToast()
        request.getOrganiseDetail(orgId: organise?.org_id ?? "") {[weak self] (organiseModel, error) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                self?.organiseDetailInfo = organiseModel
                self?.tableView.reloadData()
            }
        }
    }
}






