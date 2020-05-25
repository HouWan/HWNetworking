//
//  SocietyListModel.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/18.
//  Copyright © 2020 HouWan. All rights reserved.
//

import Foundation


class SocietyListModel: NSObject, HandyJSON {
    /// 用户头像
    var image: String?
    /// 发帖内容
    var content: String?
    /// 昵称
    var nickName: String?
    /// 门店
    var storeName: String?
    /// 帖子ID
    var msginfoId: String!
    /// 帖子图片
    var pic: [SocietyPicModel]?
    
    
    required override init() {}
}


enum SocietyPicType {
    case normal      /// 普通图
    case gif         /// GIF
    case rectangle   /// 长图
}

/// 图片模型
class SocietyPicModel: NSString {
    var picUrl: String!
    var picWidth: String?
    var picHeight: String?
    
    var PIC_URL: URL? {
        get { URL(string: picUrl) }
    }
    
    /// private for pic type
    private var _picType: SocietyPicType? = nil
    
    /// 获取图片的类型
    /// - Returns: 图片的类型`SocietyPicType`
    func picType() -> SocietyPicType {
        guard _picType != nil else {
            return _picType!
        }
        
        var picW = (picWidth as NSString?)?.doubleValue ?? 0
        var picH = (picHeight as NSString?)?.doubleValue ?? 0
        
        if picW.isNaN { picW = 0}
        if picH.isNaN { picH = 0}
        
        guard picH > 0 && picW > 0 else {
            _picType = .normal
            return _picType!
        }
        
        // 1.先判断是否图
        if picH >= picW * 2.5 {
            _picType = .rectangle
        } else {
            _picType = picUrl.lowercased().hasSuffix("gif") ? .gif : .normal
        }
        
        return _picType!
    }
    

}
