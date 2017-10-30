//
//  UYUserBaseInfoViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let inputCellIdentifier = "cellInputCellIdentifier"
fileprivate let inputIdCardCellIdentifier = "inputIdCardCellIdentifier"

fileprivate let inputCellBtnIdentifier = "inputCellBtnIdentifier"

class UYUserBaseInfoViewController: UYBaseViewController {
    
    fileprivate var userInfo:UYUserInfo = UYAPPManager.shared.userInfo!
    fileprivate var safeManager = SafeAuthManager()
    fileprivate let uploadManager = UYUploadPhotoManager()
    fileprivate let bankPickerView = UYBankPickerView()
    
    fileprivate var repeatCount :Int = 0
    fileprivate var tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    fileprivate var dataArray = [[UYInputModel]]()
    fileprivate var banksArray = [UYBankInfo]()
    fileprivate var datePicker = KZDatePickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataArray()
        navigationItem.title = "身份绑定"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "启动识别", target: self, action: #selector(showUDFaceSDK))
        getUserInfoConfig()
        bankPickerView.selectBank {[weak self] (bankInfo) in
            var inputModel :UYInputModel = (self?.dataArray[2][1])!
            inputModel.content = bankInfo.open_bank!
            inputModel.subContent = bankInfo.open_bank_code!
            self?.userInfo.open_bank = bankInfo.open_bank!
            self?.userInfo.open_bank_code = bankInfo.open_bank_code!
            
            self?.dataArray[2][1] = inputModel
            self?.tableView.reloadData()
        }
    }
    override func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.bottom.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(UINib(nibName: "UYInputTableViewCell", bundle: nil), forCellReuseIdentifier: inputCellIdentifier)
        tableView.register(UINib(nibName: "UYInputBtnTableViewCell", bundle: nil), forCellReuseIdentifier: inputCellBtnIdentifier)
        tableView.register(UINib(nibName: "UYIdCardTableViewCell", bundle: nil), forCellReuseIdentifier: inputIdCardCellIdentifier)

        let footView = UYTableFooterView(title: "完成")
        footView.delegate = self
        tableView.tableFooterView = footView
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
    }
    deinit {
        bankPickerView.removeFromSuperview()
    }
    @objc func showUDFaceSDK() {
        getUdSDKConfig()
    }
}
extension UYUserBaseInfoViewController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 2 {
            if indexPath.section == 2 && indexPath.row == 2 {
                let cell  = tableView.dequeueReusableCell(withIdentifier: inputCellBtnIdentifier, for: indexPath) as! UYInputBtnTableViewCell
                cell.indexPath = indexPath
                cell.delegate = self
                cell.inputModel = dataArray[indexPath.section][indexPath.row]
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellIdentifier, for: indexPath) as! UYInputTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            cell.inputModel = dataArray[indexPath.section][indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: inputIdCardCellIdentifier, for: indexPath) as! UYIdCardTableViewCell
            cell.delegate = self
            let inputModel:UYInputModel = dataArray[indexPath.section][indexPath.row]
            
            
            if let url1 = URL(string: inputModel.image1) {
                cell.faceBtn.kf.setImage(with:url1, for: UIControlState.normal)
            }
            if let url2 = URL(string: inputModel.image2) {
                cell.emblemBtn.kf.setImage(with: url2, for: UIControlState.normal)
            }
//            cell.faceBtn.kf.setImage(with: url1, for: UIControlState.normal, placeholder: #imageLiteral(resourceName: "user_id_back_btn"), options: nil, progressBlock: nil, completionHandler: nil)
            
            
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 110
        }
        return 46
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 5
        }
        return 0.1
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            cell.separatorInset = UIEdgeInsetsMake(0, 90, 0, 0)
            cell.layoutMargins = UIEdgeInsetsMake(0, 90, 0, 0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2  {
                let years70:TimeInterval = 24*60*60*365*70
                let minDate = Date(timeIntervalSinceNow: -years70)
                showDatePicer(maxDate: Date(), minDate: minDate, indexPath: indexPath)
            }else if indexPath.row == 3 {
                let minDate = Date(timeIntervalSinceNow: 24*60*60)
                let maxDate = Date(timeIntervalSinceNow: 24*60*60*365*70)
                showDatePicer(maxDate: maxDate, minDate: minDate, indexPath: indexPath)
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 1 {
                view.endEditing(false)
                bankPickerView.showPickerView()
            }
        }
    }
}

// MARK: - 日期选择器
extension UYUserBaseInfoViewController {
    func showDatePicer(maxDate:Date,minDate:Date,indexPath:IndexPath) {
        self.view.endEditing(false)
        var inputModel :UYInputModel = dataArray[indexPath.section][indexPath.row]

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
            self?.dataArray[indexPath.section][indexPath.row] = inputModel
            self?.tableView.reloadData()
        }
    }
}

// MARK: - 数据转换
extension UYUserBaseInfoViewController {
    func setupDataArray()  {
        let nameItem = UYInputModel(title: "姓名",content:userInfo.full_name, placeholder: "请输入本人姓名")
        
        let idCardItem = UYInputModel(title: "身份证号",content:userInfo.id_card, placeholder: "请输入本人身份证号", keyboardType: UIKeyboardType.numberPad)
        let idBeginItem = UYInputModel(title: "证件日期",content:userInfo.id_card_start,  placeholder: "请选择身份证起始日期", textFieldEnable: false)
        let idEndItem = UYInputModel(content:userInfo.id_card_end, placeholder: "请选择身份证结束日期", textFieldEnable: false)
        let addressItem = UYInputModel(title: "证件住址",content:userInfo.id_card_address,  placeholder: "请输入您身份证上的住址")
        var picItem = UYInputModel()
        if  userInfo.id_card_info_pic.characters.count > 0 {
            picItem.image1 = userInfo.id_card_info_pic
            if userInfo.id_card_nation_pic.characters.count > 0 {
                picItem.content = "有照片啦"
            }
        }
        if userInfo.id_card_nation_pic.characters.count > 0 {
            picItem.image2 = userInfo.id_card_nation_pic
        }
        
        picItem.placeholder = "请上传身份证照片"
        
        let bankNumItem = UYInputModel(title: "银行卡号",content:userInfo.bank_card_number,  placeholder: "请输入本人身份证开户的银行卡号", keyboardType: UIKeyboardType.numberPad)
        let bankItem = UYInputModel(title: "开户行",content:userInfo.open_bank,  placeholder: "请选择开户行名称", textFieldEnable: false)
        let phoneItem = UYInputModel(title: "手机号",content:userInfo.auth_mobile,  placeholder: "请输入本人实名制手机号", keyboardType: UIKeyboardType.numberPad)
        let codeItem = UYInputModel(title: "验证码", placeholder: "请输入手机号验证码", keyboardType: UIKeyboardType.numberPad)
        dataArray.removeAll()
        dataArray.append([nameItem,idCardItem,idBeginItem,idEndItem,addressItem])
        dataArray.append([picItem])
        dataArray.append([bankNumItem,bankItem,phoneItem,codeItem])
    }
    func starUdSafeSDK()  {
        DispatchQueue.main.async {
            self.safeManager.safeEngine.startIdSafe(withUserName: "", identityNumber: "", in: self)
        }
        safeManager.safeAuthFinished { (result, userInfo) in
            if result == UDIDCheckResult.success {
                
                self.userInfo.full_name = userInfo?.id_name ?? ""
                self.userInfo.id_card = userInfo?.id_no ?? ""
                self.userInfo.id_card_start = userInfo?.idcard_start ?? ""
                self.userInfo.id_card_end = userInfo?.idcard_expire ?? ""
                self.userInfo.id_card_address = userInfo?.addr_card ?? ""
                self.setupDataArray()
                self.repeatCount = 0
                self.getUserIdPic()
            }else{
                self.showTextToastAutoDismiss(msg: (userInfo?.ret_msg)!)
            }
        }
    }
}

// MARK: - 照片上传
extension UYUserBaseInfoViewController :UYIdCardTableViewCellDelegate ,UYInputTableViewCellDelegate {
    func idcardInfoFaceAction() {
        uploadImage(name: "id_card_info_pic")
    }
    func idcardNationAction() {
        uploadImage(name: "id_card_nation_pic")
    }
    func uploadImage(name:String)  {
        view.endEditing(false)
        uploadManager.uploadImage(tipsImage: "", name: name) {[weak self] (result) in
            var inputModel :UYInputModel = (self?.dataArray[1][0])!
            if name == "id_card_info_pic" {
                inputModel.image1 = result[name] as! String
            }else{
                inputModel.image2 = result[name] as! String
            }
            if inputModel.image1.characters.count > 0 && inputModel.image2.characters.count > 0 {
                inputModel.content = "有照片了"
            }
            self?.dataArray[1][0] = inputModel
            self?.tableView.reloadData()
        }
    }
    func getCodeAction() {
        let inputModel :UYInputModel = dataArray[2][2]
        let phone = inputModel.content
        if phone.characters.count != 11 {
            showTextToastAutoDismiss(msg: "请输入正确的手机号")
            return
        }
        let  cell  = tableView.cellForRow(at: IndexPath(row: 2, section: 2)) as! UYInputBtnTableViewCell
        cell.verBtn.beginCountDown()
        request.getPhoneCodeRequest(phone: phone) {[weak self] (error) -> (Void) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }
        }
    }
    func textFieldTextDidChange(indexPath: IndexPath, text: String) {
    
        var inputModel :UYInputModel = dataArray[indexPath.section][indexPath.row]
            inputModel.content = text
            dataArray[indexPath.section][indexPath.row] = inputModel
    }
}
// MARK: - 下一步按钮提交
extension UYUserBaseInfoViewController:UYTableFooterViewDelegate {
    func checkParameters() -> Bool {
        for model:UYInputModel in dataArray[0] {
            guard model.content.characters.count > 0 else {
                showTextToastAutoDismiss(msg: model.placeholder)
                return false
            }
        }
        for model:UYInputModel in dataArray[1] {
            guard model.content.characters.count > 0 else {
                showTextToastAutoDismiss(msg: model.placeholder)
                return false
            }
        }
        for model:UYInputModel in dataArray[2] {
            guard model.content.characters.count > 0 else {
                showTextToastAutoDismiss(msg: model.placeholder)
                return false
            }
        }
        return true
    }
    func loadParameters() -> [String:Any] {
        
        let nameModel :UYInputModel = dataArray[0][0]
        let idCardModel :UYInputModel = dataArray[0][1]
        let beginModel :UYInputModel = dataArray[0][2]
        let endModel :UYInputModel = dataArray[0][3]
        let addressModel :UYInputModel = dataArray[0][4]
        let pidModel :UYInputModel = dataArray[1][0]
        let bankCodeModel :UYInputModel = dataArray[2][0]
        let bankNameModel :UYInputModel = dataArray[2][1]
        let phoneModel :UYInputModel = dataArray[2][2]
        let phoneCodeModel :UYInputModel = dataArray[2][3]
        let order = safeManager.safeEngine.outOrderId ?? ""
        
        return ["full_name":nameModel.content,
                "id_card":idCardModel.content,
                "id_card_start":beginModel.content,
                "id_card_end":endModel.content,
                "id_card_address":addressModel.content,
                "id_card_info_pic":pidModel.image1,
                "id_card_nation_pic":pidModel.image2,
                "auth_mobile":phoneModel.content,
                "bank_card_number":bankCodeModel.content,
                "open_bank_code":bankNameModel.subContent,
                "open_bank":bankNameModel.content,
                "code":phoneCodeModel.content,
                "udcredit_order":order,
        ]
    }
    func footButtonAction() {
        guard checkParameters() else {
            return
        }
        let parameters = loadParameters()
        showWaitToast()
        request.submitUserInfo(parameters: parameters) { (error) -> (Void) in
            if error != nil {
                self.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self.dismissToast()
                self.popBackAction()
            }
        }
    }
}


// MARK: - 人脸识别
extension UYUserBaseInfoViewController {
    func getUserInfoConfig() {
        showWaitToast()
        request.getUserInfoConfig {[weak self] (bannks, error) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                self?.banksArray = bannks!
                self?.bankPickerView.banksArray = bannks!
            }
        }
    }
   
    func getUdSDKConfig() {
        showWaitToast()
        request.getUserUDCreditRequest {[weak self] (creditConfig, error) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                self?.safeManager.safeEngine.outOrderId = creditConfig?.order
                self?.safeManager.safeEngine.authKey = creditConfig?.key
                self?.safeManager.safeEngine.userId = creditConfig?.user_id
                self?.safeManager.safeEngine.notificationUrl = creditConfig?.notify_url
                if creditConfig?.safe_mode == "0" {
                    self?.safeManager.safeEngine.safeMode = UDIDSafeMode.high
                }else if creditConfig?.safe_mode == "1" {
                    self?.safeManager.safeEngine.safeMode = UDIDSafeMode.medium
                }else if creditConfig?.safe_mode == "2" {
                    self?.safeManager.safeEngine.safeMode = UDIDSafeMode.low
                }
                self?.starUdSafeSDK()
            }
        }
    }
    func getUserIdPic() {
        let order = safeManager.safeEngine.outOrderId ?? ""
        showWaitToast()
        request.getUserUDCreditUserPic(udcredit_order: order) {[weak self] (UserPic, error) in
            if error != nil {
                if (self?.repeatCount)! < 3 {
                    self?.getUserIdPic()
                    self?.repeatCount += 1
                }else{
                    self?.showTextToastAutoDismiss(msg: (error?.description)!)
                }
            }else{
                self?.dismissToast()
                self?.userInfo.id_card_info_pic = UserPic?.id_card_info_pic ?? ""
                self?.userInfo.id_card_nation_pic = UserPic?.id_card_nation_pic ?? ""
                var picItem = UYInputModel()
                picItem.image1 = UserPic?.id_card_info_pic ?? ""
                picItem.image2 = UserPic?.id_card_nation_pic ?? ""
                picItem.content = "有照片啦"
                picItem.placeholder = "请上传身份证照片"
                self?.dataArray[1] = [picItem]
                self?.tableView.reloadData()
            }
        }
    }
    
}
