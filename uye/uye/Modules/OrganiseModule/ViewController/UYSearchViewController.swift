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
    
    fileprivate var isFirstTime = true
    fileprivate let tagsView :UIView = UIView()
    fileprivate let tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    fileprivate var keyWord:String = ""
    fileprivate let searchBar = UYSearchBar()
    fileprivate let hotSearch:UYTagView = UYTagView(title: "热门搜索")
    fileprivate let historyView:UYTagView = UYTagView(title: "历史记录", showDelete: true)

    fileprivate var organiseList:[UYOrganiseModel] = []
    
    fileprivate var firstload = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        getSearchHistory()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstload == true {
            self.searchBar.becomeFirstResponder()
            firstload = false
        }
    }
    override func setupUI() {
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        searchBar.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 30)
        searchBar.delegate = self
        searchBar.searchStyle()
        navigationItem.titleView = searchBar
         let cancelBtn = UIBarButtonItem(title: "    取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = cancelBtn

        showErorView()
        errorView.isHidden = true
        setupTableView()
        addTagsView()
        
    }

    @objc func cancelAction() {
        searchBar.resignFirstResponder()
        popBackAction()
    }
}
// MARK: - 网络请求数据加载
extension UYSearchViewController {
    func getOrganiseList(isRefash:Bool = true) {
        showWaitToast()
        request.getOrganiseList(isRefash: isRefash, word: keyWord) {[weak self] (list, error) -> (Void) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                if isRefash {
                    self?.organiseList.removeAll()
                }
                self?.organiseList = (self?.organiseList)! + (list?.organizes)!
                if (self?.organiseList.isEmpty)! {
                    self?.errorView.isHidden = false
                    self?.view.bringSubview(toFront: (self?.errorView)!)
                }else{
                    self?.errorView.isHidden = true
                    self?.view.bringSubview(toFront: (self?.tableView)!)
                    self?.tableView.reloadData()
                }
                
            }
        }
    }
    func getSearchHistory() {
        showWaitToast()
        request.getSearchDataRequest { (searchModel, error) in
            if (error != nil) {
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                self.updateTagsViewWithSearchData(searchData: searchModel!)
            }
        }
    }
}

// MARK: - 设置页面之热门搜索和历史记录
extension UYSearchViewController {
    func addTagsView() {
        view.addSubview(tagsView)
        tagsView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
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
            make.top.equalTo(hotSearch.snp.bottom).offset(15)
            make.left.right.equalTo(0)
            make.height.equalTo(historyView.estimatedHeight)
        }
    }

    func updateTagsViewWithSearchData(searchData:UYSearchModel)  {
        hotSearch.tagsArray = searchData.hot_search ?? []
        historyView.tagsArray = searchData.history ?? []


    }
}
extension UYSearchViewController : UYTagViewDelegate {
    func deleteHistory() {
        
    }
    func tagViewEstimatedHeight(tagView: UYTagView, height: CGFloat) {
        tagView.snp.updateConstraints { (make) in
            make.height.equalTo(tagView.estimatedHeight)
        }
    }

    func tagAcion(title: String) {
        searchBar.text = title
        
       _ = textFieldShouldReturn(searchBar)
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
            make.top.equalTo(kNavigationHeight)
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
        let organiseDetailVC = UYOrganiseDetailViewController()
        organiseDetailVC.organise = organiseList[indexPath.row]
        pushToNextVC(nextVC: organiseDetailVC)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


// MARK: - SearchBarDelegate
extension UYSearchViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (searchBar.text?.isEmpty)! {
            showTextToast(msg: searchBar.placeholder!)
            return false
        }
        searchBar.resignFirstResponder()
        keyWord = textField.text!
        getOrganiseList(isRefash: true)
        return true
    }


}


