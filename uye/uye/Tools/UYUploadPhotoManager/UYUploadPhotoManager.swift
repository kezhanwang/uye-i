//
//  UYUploadPhotoManager.swift
//  uye
//
//  Created by Tintin on 2017/10/21.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

typealias UploadPhotoHandler = ([String:Any])->()

class UYUploadPhotoManager: NSObject {
    fileprivate var request = UYNetRequest()
    fileprivate var photoPicker = KZPhotoPicker(config: KZPhotoPickerConfig())
    fileprivate var handler:UploadPhotoHandler?
    
   
}

// MARK: - 选取图片
extension UYUploadPhotoManager {
    
    func uploadMultipleImages(name:String = "",beginIndex:Int,maxCount:Int , complete:@escaping UploadPhotoHandler)   {
        handler = complete
        photoPicker?.config.allowsMultipleSelection = true
        photoPicker?.config.maxNumberOfSelection = UInt(maxCount)
        photoPicker?.showActionSheetShowTitle(true, complete: { (result, error, success) in
            var images:[UYImageModel] = []
            var index = beginIndex;
            
            for image:UIImage in result as! [UIImage] {
                var data :Data?  = UIImagePNGRepresentation(image)
                if data == nil {
                    data = UIImageJPEGRepresentation(image, 1)
                }
                if data == nil {
                    showTextToast(msg: "图片格式不支持")
                }else{
                    let imageModel = UYImageModel(name: "\(name)_\(index)", data: data!)
                    images.append(imageModel)
                    index = index + 1;
                }
            }
            self.uploadImageToServer(images: images)
        })
    }
    func uploadImage(tipsImage:String = "",name:String = "", complete:@escaping UploadPhotoHandler)  {
        handler = complete
        photoPicker?.config.allowsMultipleSelection = false
        
        photoPicker?.showActionSheetShowTitle(false, complete: { (result, error, success) in
            if error != nil {
                showTextToast(msg: (error?.localizedDescription)!)
            }else{
                let image :UIImage = result?.first as! UIImage
                let width = kScreenWidth*4
                let compressImage = image.compressImage(compressWidth: width)
                
                self.uploadImageToServer(image: compressImage, name: name)
              
            }
        })
    }
}
// MARK: - 上传图片
extension UYUploadPhotoManager {
    fileprivate func uploadImageToServer(image:UIImage,name:String) {
        var data :Data?  = UIImagePNGRepresentation(image)
        if data == nil {
            data = UIImageJPEGRepresentation(image, 1)
        }
        if data == nil {
        showTextToast(msg: "图片格式不支持")
            return
        }
        let images:[UYImageModel] = [UYImageModel(name: name, data: data!)]
        uploadImageToServer(images: images)
    }
    fileprivate func uploadImageToServer(images:[UYImageModel]) {
        request.uploadImageRequest(images: images) {[weak self] (picInfo, error) -> (Void) in
            if error == nil {
                if self?.handler != nil {
                    self?.handler!(picInfo!)
                }
            }
        }
    }
}
extension UIImage {
   fileprivate func compressImage(compressWidth:CGFloat) -> UIImage {
        var size = self.size
        let orWidth = size.width
        let orHeight = size.height
        
        if size.width > compressWidth {
            size.width = compressWidth
            size.height = size.width/orWidth*orHeight
        }else{
            return self
        }
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
