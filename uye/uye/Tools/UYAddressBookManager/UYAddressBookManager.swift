//
//  UYAddressBookManager.swift
//  uye
//
//  Created by Tintin on 2017/10/21.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import AddressBook
typealias UploadAddressBookHandler = (Bool,String) -> Void
class UYAddressBookManager: NSObject {
    var addressBookArray = [Any]()
    var request = UYNetRequest()
    var uploadHandler :UploadAddressBookHandler?
    
    var addressBook:ABAddressBook?
    
    class var isRejectReadAddressBook:Bool {
        return ABAddressBookGetAuthorizationStatus() == .denied
    }
    
    static let shared = UYAddressBookManager()

    func uploadAddressBook(complete:@escaping UploadAddressBookHandler)  {
        uploadHandler = complete
        
        //发出授权信息
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        if (sysAddressBookStatus == ABAuthorizationStatus.notDetermined) {
            //定义一个错误标记对象，判断是否成功
            var error:Unmanaged<CFError>?
            addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
            
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    
                    //获取并遍历所有联系人记录
                    self.getAddressBook(complete: { (suce) in
                        if suce {
                            self.uploadAddressBookToServer()
                        }else{
                            if self.uploadHandler != nil {
                                self.uploadHandler!(false,"获取失败")
                            }
                        }
                    })
                }else {
                    if self.uploadHandler != nil {
                        self.uploadHandler!(false,"权限不足，请在设置中打开通讯录权限")
                    }
                }
            })
        }
        else if (sysAddressBookStatus == ABAuthorizationStatus.denied ||
            sysAddressBookStatus == ABAuthorizationStatus.restricted) {
            if self.uploadHandler != nil {
                self.uploadHandler!(false,"权限不足，请在设置中打开通讯录权限")
            }
            
        }
        else if (sysAddressBookStatus == ABAuthorizationStatus.authorized) {
            //获取并遍历所有联系人记录
            self.getAddressBook(complete: { (succe) in
                if succe {
                    self.uploadAddressBookToServer()
                }else{
                    if self.uploadHandler != nil {
                        self.uploadHandler!(false,"获取失败")
                    }
                    
                }
            })
        }
    }

}

// MARK: - 读取通讯录内容
extension UYAddressBookManager {
    func getAddressBook(complete:@escaping(_ success:Bool)->Void)  {
        let sysContacts:NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook)
            .takeRetainedValue() as NSArray
        
        for contact in sysContacts {
            var onePersion = [String:Any]()
            
            //获取姓
            let lastName = ABRecordCopyValue(contact as ABRecord, kABPersonLastNameProperty)?
                .takeRetainedValue() as! String? ?? ""
            print("姓：\(lastName)")
            
            //获取名
            let firstName = ABRecordCopyValue(contact as ABRecord, kABPersonFirstNameProperty)?
                .takeRetainedValue() as! String? ?? ""
            print("名：\(firstName)")
            
            
            //获取电话
            let phoneValues:ABMutableMultiValue? =
                ABRecordCopyValue(contact as ABRecord, kABPersonPhoneProperty).takeRetainedValue()
            var phones = [String]()
            
            if phoneValues != nil {
                for i in 0 ..< ABMultiValueGetCount(phoneValues){
                    
                    // 获得标签名
                    let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, i).takeRetainedValue()
                        as CFString;
                    // 转为本地标签名（能看得懂的标签名，比如work、home）
                    let localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel)
                        .takeRetainedValue() as String
                    
                    let value = ABMultiValueCopyValueAtIndex(phoneValues, i)
                    let phone = value?.takeRetainedValue() as! String
                    phones.append(phone)
                    print("  \(localizedPhoneLabel):\(phone)")
                }
            }
            
            //获取Email
            let emailValues:ABMutableMultiValue? =
                ABRecordCopyValue(contact as ABRecord as ABRecord, kABPersonEmailProperty).takeRetainedValue()
            var emails = [String]()
            
            if emailValues != nil {
                for i in 0 ..< ABMultiValueGetCount(emailValues){
                    
                    // 获得标签名
                    let label = ABMultiValueCopyLabelAtIndex(emailValues, i).takeRetainedValue()
                        as CFString;
                    let localizedLabel = ABAddressBookCopyLocalizedLabel(label)
                        .takeRetainedValue() as String
                    
                    let value = ABMultiValueCopyValueAtIndex(emailValues, i)
                    let email = value?.takeRetainedValue() as! String
                    emails.append(email)
                    print("  \(localizedLabel):\(email)")
                }
            }
            onePersion["LastName"] = lastName
            onePersion["FirstName"] = firstName
            onePersion["Phones"] = phones
            onePersion["Emails"] = emails
            
            addressBookArray.append(onePersion)
        }
        complete(true)
    }
   
}
extension UYAddressBookManager {
    func uploadAddressBookToServer()  {
     
        if let data = try? JSONSerialization.data(withJSONObject: addressBookArray, options: JSONSerialization.WritingOptions.prettyPrinted) {
            let jsonStrng = String(data: data, encoding: String.Encoding.utf8) ?? ""
            request.submitUserMobileBook(parameters: ["mobile":jsonStrng], complete: { (error) -> (Void) in
                if error != nil {
                    if self.uploadHandler != nil {
                        self.uploadHandler!(false,(error?.description)!)
                    }
                }else{
                    if self.uploadHandler != nil {
                        self.uploadHandler!(true,"上传成功")
                    }
                }
            })
        }
        
    }
}
