//
//  HWAPI.swift
//  LianDuoDuo
//
//  Created by HouWan on 2020/8/17.
//  Copyright © 2020 CSData. All rights reserved.
//

import Foundation
import Alamofire

/// Type representing HTTP methods.
public enum HWHTTPMethod {
    /// Common HTTP methods.
    case delete, get, patch, post, put
}

/// API interface protocol
public protocol HWAPIProtocol {
    /// API URL address
    var url: String { get }
    /// API description information
    var description: String { get }
    /// API additional information, eg: Author | Note...
    var extra: String? { get }
    /// Type representing HTTP methods.
    var method: HWHTTPMethod { get }
}

/// Extension method
public extension HWAPIProtocol {

    /// 根据`HWAPIProtocol`进行一个网络请求
    ///
    /// - Parameters:
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///   - success: Successful response
    ///   - failed: Failed response
    ///
    func fetch(_ parameters: [String: Any]? = nil, headers: [String: String]? = nil, success: HNSuccessClosure?, failed: HNFailedClosure?) {
        let task = HN.fetch(self, parameters: parameters, headers: headers)
        if let s = success {
            task.success(s)
        }
        if let f = failed {
            task.failed(f)
        }
    }

    /// 根据`HWAPIProtocol`进行一个网络请求
    ///
    /// - Parameters:
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    func fetch(_ parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> HWNetworkRequest {
        HN.fetch(self, parameters: parameters, headers: headers)
    }
}

/// 为了`HWAPIProtocol`给`HWNetworking`扩展的网络请求方法
public extension HWNetworking {
    /// Creates a request, for `HWAPIProtocol`
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    func fetch(_ api: HWAPIProtocol, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> HWNetworkRequest {
        let method = methodWith(api.method)
        let task = request(url: api.url, method: method, parameters: parameters, headers: headers)
        task.description = api.description
        task.extra = api.extra
        return task
    }
}

/// Function to convert request method
private func methodWith(_ m: HWHTTPMethod) -> Alamofire.HTTPMethod {
    // case delete, get, patch, post, put
    switch m {
    case .delete: return .delete
    case .get: return .get
    case .patch: return .patch
    case .post: return .post
    case .put: return .put
    }
}
