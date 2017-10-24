//
//  UYSearchViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import MJRefresh
let organisterCellIdentifier = "organisterCellIdentifier"

class UYSearchViewController: UYBaseViewController {
    
    fileprivate let tagsView :UIView = UIView()
    fileprivate let tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
//    fileprivate let searchView = UYSearchBarView()
    fileprivate let searchBar = UYSearchBar()
    fileprivate let hotSearch:UYTagView = UYTagView(title: "热门搜索")
    fileprivate let historyView:UYTagView = UYTagView(title: "历史记录", showDelete: true)

    fileprivate var organiseList:[UYOrganiseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    override func setupUI() {
        
//        searchView.searchBar.placeholder = "请输入您要搜索的机构名称"
//        searchView.searchBar.showsCancelButton = true
//        searchView.searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: kScreenWidth-100, height: 30)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
         let cancelBtn = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = cancelBtn
        
//        searchBar.snp.makeConstraints { (make) in
//            make.left.equalTo(16)
//            make.top.bottom.equalTo(0)
//            make.right.equalTo(-16)
//        }
        
//        changeSearchBarCancelBtnTitleColor(view: searchView.searchBar)
//        searchView.searchBar.becomeFirstResponder()
        showErorView()
        errorView.isHidden = true
        setupTableView()
        addTagsView()
        getSearchData()
    }

    @objc func cancelAction(){
        popBackAction()
    }
}
// MARK: - 网络请求数据加载
extension UYSearchViewController {
    func getOrganiseList(isRefash:Bool = true) {
        showWaitToast()
        request.getOrganiseList(isRefash: isRefash, word: "上海") {[weak self] (list, error) -> (Void) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                self?.organiseList = (self?.organiseList)! + (list?.organizes)!
                if (self?.organiseList.isEmpty)! {
                    self?.errorView.isHidden = false
                    self?.view.bringSubview(toFront: (self?.errorView)!)
                }else{
//                    self?.tableView.mj_footer.endRefreshing()

                    self?.errorView.isHidden = true
                    self?.view.bringSubview(toFront: (self?.tableView)!)
                    self?.tableView.reloadData()
                }
                
            }
        }
    }
    func getSearchData() {
        showWaitToast()
        request.getSearchDataRequest { [weak self] (seargModel, error:UYError?) in
            self?.dismissToast()
            if error == nil {
                self?.updateTagsViewWithSearchData(searchData: seargModel!)
            }
        }
    }
}

// MARK: - 设置页面之热门搜索和历史记录
extension UYSearchViewController {
    func addTagsView() {
        view.addSubview(tagsView)
        tagsView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaHeight)
            make.left.right.bottom.equalTo(0)
        }
        hotSearch.tagsArray = []
        hotSearch.delegate = self
        tagsView.addSubview(hotSearch)
        hotSearch.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(hotSearch.estimatedHeight)
        }
        
        historyView.tagsArray = []
        historyView.delegate = self
        tagsView.addSubview(historyView)
        historyView.snp.makeConstraints { (make) in
            make.top.equalTo(20+hotSearch.estimatedHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(historyView.estimatedHeight)
        }
    }
    func updateTagsViewWithSearchData(searchData:UYSearchModel)  {
        hotSearch.tagsArray = searchData.hot_search ?? []
        historyView.tagsArray = searchData.history ?? []
        hotSearch.snp.remakeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(hotSearch.estimatedHeight)        }
        historyView.snp.remakeConstraints { (make) in
            make.top.equalTo(20+hotSearch.estimatedHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(historyView.estimatedHeight)        }

    }
}
extension UYSearchViewController : UYTagViewDelegate {
    func deleteHistory() {
        
    }
    func tagAcion(title: String) {
        searchBar.text = title
        
//        searchView.searchBar.text = title
       _ = textFieldShouldReturn(searchBar)
//        searchBarSearchButtonClicked(searchView.searchBar)
    }
}
// MARK: - 设置页面之搜索无结果页面
extension UYSearchViewController {
    func showErorView()  {
        setupErrorView(image: "search_error_icon", title: "抱歉！暂无相关搜索结果~")
        errorView.isHidden = false
    }
    func hiddenErrorView()   {
        errorView.isHidden = true
    }
}

// MARK: - 搜索有结果页面
extension UYSearchViewController {
    func setupTableView()  {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaHeight)
            make.left.right.bottom.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "UYOrganiseTableViewCell", bundle: nil), forCellReuseIdentifier: organisterCellIdentifier)
        
        let refashFooter = MJRefreshAutoFooter {[weak self] in
            self?.getOrganiseList(isRefash: false)
        }
        tableView.mj_footer = refashFooter
        
    }
}
extension UYSearchViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organiseList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: organisterCellIdentifier, for: indexPath) as!  UYOrganiseTableViewCell
        cell.setupCell(organise: organiseList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quetionVC = UYQuestionnaireViewController()
        quetionVC.org_id = organiseList[indexPath.row].org_id ?? ""
        pushToNextVC(nextVC: quetionVC)
        
//        let organiseDetailVC = UYOrganiseDetailViewController()
//        organiseDetailVC.organise = organiseList[indexPath.row]
//        pushToNextVC(nextVC: organiseDetailVC)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
}


// MARK: - SearchBarDelegate
extension UYSearchViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (searchBar.text?.isEmpty)! {
            showTextToastAutoDismiss(msg: searchBar.placeholder!)
            return false
        }
        searchBar.resignFirstResponder()
        getOrganiseList(isRefash: true)
        return true
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if (searchBar.text?.isEmpty)! {
//            showTextToastAutoDismiss(msg: searchBar.placeholder!)
//            return
//        }
//        changeSearchBarCancelBtnTitleColor(view: searchBar)
//        searchBar.resignFirstResponder()
//        getOrganiseList(isRefash: true)
//    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        popBackAction()
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()

    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        changeSearchBarCancelBtnTitleColor(view: searchBar)
//    }
//    func changeSearchBarCancelBtnTitleColor(view:UIView) {
//        if view.isKind(of: UIButton.self) {
//            let getBtn = view as! UIButton
//            getBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//            getBtn.isEnabled = true
//            getBtn.isUserInteractionEnabled = true
//            return;
//        }else{
//            for subView in view.subviews {
//                changeSearchBarCancelBtnTitleColor(view: subView)
//            }
//        }
//    }
}


