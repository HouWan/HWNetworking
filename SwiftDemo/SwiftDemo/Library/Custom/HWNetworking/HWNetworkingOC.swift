//
//  HWNetworkingOC.swift
//  LianDuoDuo
//
//  Created by HouWan on 2020/8/14.
//  Copyright © 2020 CSData. All rights reserved.
//
//  swiftlint:disable all
//

import UIKit

/// 封装OC调用网络请求
@objc class HWNetworkingOC: NSObject {

    /// POST请求
    ///
    /// - Parameters:
    ///   - url: 请求的URL，是全地址
    ///   - info: 请求的描述说明，可以为nil，比如: 首页的请求
    ///   - parameters: 请求参数，可能为nil
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///   - success: 请求成功的响应回调
    ///   - failed: 请求失败的响应回调
    @objc static func POST(_ url: String, info: String?, parameters: [String: Any]?, headers: [String: String]?, success: @escaping HNSuccessClosure, failed: @escaping HNFailedClosure) {
        HN.POST(url: url, parameters: parameters, headers: headers).success(success).failed { error in
            failed(error)
        }.description = info
    }

    @objc static func POST(_ url: String, info: String?, parameters: [String: Any]?, success: @escaping HNSuccessClosure, failed: @escaping HNFailedClosure) {
        HN.POST(url: url, parameters: parameters, headers: nil).success(success).failed { error in
            failed(error)
        }.description = info
    }

    /// GET请求
    ///
    /// - Parameters:
    ///   - url: 请求的URL，是全地址
    ///   - info: 请求的描述说明，可以为nil，比如: 首页的请求
    ///   - parameters: 请求参数，可能为nil
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///   - success: 请求成功的响应回调
    ///   - failed: 请求失败的响应回调
    @objc static func GET(_ url: String, info: String?, parameters: [String: Any]?, headers: [String: String]?, success: @escaping HNSuccessClosure, failed: @escaping HNFailedClosure) {
        HN.GET(url: url, parameters: parameters, headers: headers).success(success).failed { error in
            failed(error)
        }.description = info
    }

    @objc static func GET(_ url: String, info: String?, parameters: [String: Any]?, success: @escaping HNSuccessClosure, failed: @escaping HNFailedClosure) {
        HN.GET(url: url, parameters: parameters, headers: nil).success(success).failed { error in
            failed(error)
        }.description = info
    }

    @objc static func GET(_ url: String, info: String?, success: @escaping HNSuccessClosure, failed: @escaping HNFailedClosure) {
        HN.GET(url: url, parameters: nil, headers: nil).success(success).failed { error in
            failed(error)
        }.description = info
    }
}
