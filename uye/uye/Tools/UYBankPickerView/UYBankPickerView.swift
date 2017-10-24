//
//  UYBankPickerView.swift
//  uye
//
//  Created by Tintin on 2017/10/22.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let tableTopHeight = 250
fileprivate let banCellIdentifier = "bankCellIdentifier"
typealias BankSelectorHandler = (UYBankInfo)->Void
class UYBankPickerView: UIView {
    var banksArray:[UYBankInfo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var bankHanlder:BankSelectorHandler?
    
    let tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    override init(frame: CGRect) {
        super.init(frame: frame)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(0)
        }
        alpha = 0
        backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        isHidden = true
        
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(kScreenHeight)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 45
        tableView.bounces = false
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "UYBankTableCell", bundle: nil), forCellReuseIdentifier: banCellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func selectBank(complete:@escaping (UYBankInfo) -> Void)  {
        bankHanlder = complete
    }
}
extension UYBankPickerView :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banksArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: banCellIdentifier, for: indexPath) as! UYBankTableCell
        let bank = banksArray[indexPath.row]
        cell.bankNameLabel.text =  bank.open_bank
        if let url = URL(string: bank.icon!) {
            cell.bankIcon.kf.setImage(with: url)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let bank = banksArray[indexPath.row]
        bank.isSelected = false
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 64))
        headView.backgroundColor = UIColor.white
        let backBtn = UIButton()
        backBtn.setImage(#imageLiteral(resourceName: "bacn_icon"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(dismissPickerView), for: UIControlEvents.touchUpInside)
        headView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(headView)
        }
        let titleLabel = UILabel()
        headView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.blackText
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = "请选择发卡行"
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(headView)
        }
        return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bank = banksArray[indexPath.row]
        bank.isSelected = true
        if bankHanlder != nil {
            bankHanlder!(bank)
        }
        dismissPickerView()
    }
}

// MARK: - 展示与消失
extension UYBankPickerView {
    func showPickerView() {
        guard isHidden == true else {
            return
        }
        self.isHidden = false
        self.tableView.snp.updateConstraints { (make) in
            make.top.equalTo(tableTopHeight)
        }
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.layoutIfNeeded()
        }
    }
    @objc func dismissPickerView()  {
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(kScreenHeight)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.layoutIfNeeded()
        }) { (finish) in
            if finish {
                self.isHidden = true

            }
        }
    }
}
