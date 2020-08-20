//
//  HWNetworkingError.swift
//  LianDuoDuo
//
//  Created by HouWan on 2020/8/4.
//  Copyright © 2020 CSData. All rights reserved.
//

import Foundation

/// 请求的错误反馈，继承`NSObject`为了让OC也能调用
public class HWNetworkingError: NSObject {
    /// 错误码
    @objc var code = -1
    /// 错误描述
    @objc var localizedDescription: String

    init(code: Int, desc: String) {
        self.code = code
        self.localizedDescription = desc
        super.init()
    }
}
