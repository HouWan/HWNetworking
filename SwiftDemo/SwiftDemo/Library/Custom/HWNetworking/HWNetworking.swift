//
//  Created by HouWan on 2020/05/23.
//  Copyright © 2020年 HouWan. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//
//
//           ~~ 天地保佑   永无BUG ~~
//                   _ooOoo_
//                  o8888888o
//                  88" . "88
//                  (| -_- |)
//                  O\  =  /O
//               ____/`---'\____
//             .'  \\|     |//  `.
//            /  \\|||  :  |||//  \
//           /  _||||| -:- |||||-  \
//           |   | \\\  -  /// |   |
//           | \_|  ''\---/''  |   |
//            \  .-\__  `-`  ___/-. /
//          ___`. .'  /--.--\  `. . __
//       ."" '<  `.___\_<|>_/___.'  >'"".
//      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//      \  \ `-.   \_ __\ /__ _/   .-` /  /
// ======`-.____`-.___\_____/___.-`____.-'======
//



import Foundation
import Alamofire


/// Closure type executed when the request is successful
public typealias HNSuccessClosure = (_ JSON: Any) -> Void
/// Closure type executed when the request is failed
public typealias HNFailedClosure = (_ error: Any) -> Void
/// Closure type executed when monitoring the upload or download progress of a request.
public typealias HNProgressHandler = (Progress) -> Void


/// Defines the various states of network reachability.
public enum HWReachabilityStatus {
    /// It is unknown whether the network is reachable.
    case unknown
    /// The network is not reachable.
    case notReachable
    /// The connection type is either over Ethernet or WiFi.
    case ethernetOrWiFi
    /// The connection type is a cellular connection.
    case cellular
}


// ============================================================================

/// Reference to `HWNetworking.shared` for quick bootstrapping and examples.
public let HN = HWNetworking.shared

/// This notification will be sent when you call method `startMonitoring()` to monitor the network
/// and the network status changes.
public let kNetworkStatusNotification = NSNotification.Name("kNetworkStatusNotification")

// ============================================================================


public class HWNetworking {
    /// For singleton pattern
    public static let shared = HWNetworking()
    /// TaskQueue Array for (`Alamofire.Request` & callback)
    private var taskQueue = [HWNetworkRequest]()
    /// `Session` creates and manages Alamofire's `Request` types during their lifetimes.
    var sessionManager: Alamofire.Session!
    
    /// Network reachability manager, The first call to method `startMonitoring()` will be initialized.
    var reachability: NetworkReachabilityManager? = nil
    /// The newwork status, `.unknown` by default, You need to call the `startMonitoring()` method
    var networkStatus: HWReachabilityStatus = .unknown

    // MARK: - Core method
        
    /// Initialization
    /// `private` for singleton pattern
    private init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 20  // Timeout interval
        config.timeoutIntervalForResource = 20  // Timeout interval
        sessionManager = Alamofire.Session(configuration: config)
    }
    
    
    /// Creates a `DataRequest` from a `URLRequest` created using the passed components
    ///
    /// - Parameters:
    ///   - method: `HTTPMethod` for the `URLRequest`. `.get` by default.
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    /// - Returns:  The created `DataRequest`.
    public func request(url: String,
                        method: HTTPMethod = .get,
                        parameters: [String: Any]?,
                        headers: [String: String]? = nil,
                        encoding: ParameterEncoding = URLEncoding.default) -> HWNetworkRequest {
        let task = HWNetworkRequest()
        
        var h: HTTPHeaders? = nil
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }
        
        task.request = sessionManager.request(url,
                                              method: method,
                                              parameters: parameters,
                                              encoding: encoding,
                                              headers: h).validate().responseJSON { [weak self] response in
            task.handleResponse(response: response)
            
            if let index = self?.taskQueue.firstIndex(of: task) {
                self?.taskQueue.remove(at: index)
            }
        }
        taskQueue.append(task)
        return task
    }
    
    
    /// Creates a `UploadRequest` from a `URLRequest` created using the passed components
    ///
    /// - Parameters:
    ///   - method: `HTTPMethod` for the `URLRequest`. `.post` by default.
    ///   - parameters: 为了方便格式化参数，采用了[String: String]格式. `nil` by default.
    ///   - datas: Data to upload. The data is encapsulated here! more see `HWMultipartData`
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    /// - Returns: The created `UploadRequest`.
    public func upload(url: String,
                       method: HTTPMethod = .post,
                       parameters: [String: String]?,
                       datas: [HWMultipartData],
                       headers: [String: String]? = nil) -> HWNetworkRequest {
        let task = HWNetworkRequest()
        
        var h: HTTPHeaders? = nil
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }
        
        task.request = sessionManager.upload(multipartFormData: { (multipartData) in
            // 1.参数 parameters
            if let parameters = parameters {
                for p in parameters {
                    multipartData.append(p.value.data(using: .utf8)!, withName: p.key)
                }
            }
            // 2.数据 datas
            for d in datas {
                multipartData.append(d.data, withName: d.name, fileName: d.fileName, mimeType: d.mimeType)
            }
        }, to: url, method: method, headers: h).uploadProgress(queue: .main, closure: { (progress) in
            task.handleProgress(progress: progress)
        }).validate().responseJSON(completionHandler: { [weak self] response in
            task.handleResponse(response: response)
            
            if let index = self?.taskQueue.firstIndex(of: task) {
                self?.taskQueue.remove(at: index)
            }
        })
        return task
    }
     
    
    /// Creates a `DownloadRequest`...
    /// - warning: Has not been implemented
    /// - Returns: The created `DownloadRequest`.
    public func download(url: String, method: HTTPMethod = .post) -> HWNetworkRequest {
        // TODO...
        fatalError("download(...) has not been implemented")
    }
}

/// Shortcut method for `HWNetworking`
extension HWNetworking {
        
    /// Creates a POST request
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func POST(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> HWNetworkRequest {
        request(url: url, method: .post, parameters: parameters, headers: nil)
    }
    
    /// Creates a POST request for upload data
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func POST(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, datas: [HWMultipartData]? = nil) -> HWNetworkRequest {
        guard datas != nil else {
            return request(url: url, method: .post, parameters: parameters, headers: nil)
        }
        return upload(url: url, parameters: parameters, datas: datas!, headers: headers)
    }
    
    /// Creates a GET request
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func GET(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> HWNetworkRequest {
        request(url: url, method: .get, parameters: parameters, headers: nil)
    }
}


/// Detect network status 监听网络状态
extension HWNetworking {
    /// Starts monitoring for changes in network reachability status.
    public func startMonitoring() {
        if reachability == nil {
            reachability = NetworkReachabilityManager.default
        }
        
        reachability?.startListening(onQueue: .main, onUpdatePerforming: { [unowned self] (status) in
            switch status {
            case .notReachable:
                self.networkStatus = .notReachable
            case .unknown:
                self.networkStatus = .unknown
            case .reachable(.ethernetOrWiFi):
                self.networkStatus = .ethernetOrWiFi
            case .reachable(.cellular):
                self.networkStatus = .cellular
            }
            // Sent notification
            NotificationCenter.default.post(name: kNetworkStatusNotification, object: nil)
            debugPrint("sssssss: \(self.networkStatus)")
        })
    }
    
    /// Stops monitoring for changes in network reachability status.
    public func stopMonitoring() {
        guard reachability != nil else { return }
        reachability?.stopListening()
    }
}



/// RequestTask
public class HWNetworkRequest: Equatable {
    
    /// Alamofire.DataRequest
    var request: DataRequest?
    
    /// request response callback
    private var successHandler: HNSuccessClosure?
    /// request failed callback
    private var failedHandler: HNFailedClosure?
    /// `ProgressHandler` provided for upload/download progress callbacks.
    private var progressHandler: HNProgressHandler?
    
    
    // MARK: - Handler
    
    /// Handle request response
    func handleResponse(response: AFDataResponse<Any>) {
        switch response.result {
        case .failure(let error):
            if let closure = failedHandler  {
                closure(error.localizedDescription)
            }
   
        case .success(let JSON):
            if let closure = successHandler  {
                closure(JSON)
            }
        }
        clearReference()
    }
    
    /// Processing request progress (Only when uploading files)
    func handleProgress(progress: Foundation.Progress) {
        if let closure = progressHandler  {
            closure(progress)
        }
    }
    
    // MARK: - Callback
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once the request has finished.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func success(_ closure: @escaping HNSuccessClosure) -> Self {
        successHandler = closure
        return self
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once the request has finished.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func failed(_ closure: @escaping HNFailedClosure) -> Self {
        failedHandler = closure
        return self
    }
    
    /// Sets a closure to be called periodically during the lifecycle of the instance as data is sent to the server.
    ///
    /// - Note: Only the last closure provided is used.
    ///
    /// - Parameters:
    ///   - closure: The closure to be executed periodically as data is sent to the server.
    ///
    /// - Returns:   The instance.
    @discardableResult
    public func progress(closure: @escaping HNProgressHandler) -> Self {
        progressHandler = closure
        return self
    }
    
    /// Free memory
    func clearReference() {
        successHandler = nil
        failedHandler = nil
        progressHandler = nil
    }
}

/// Equatable for `HWNetworkRequest`
extension HWNetworkRequest {
    /// Returns a Boolean value indicating whether two values are equal.
    public static func == (lhs: HWNetworkRequest, rhs: HWNetworkRequest) -> Bool {
        return lhs.request?.id == rhs.request?.id
    }
}


// ============================================================================
// ================================Boundary====================================
// ============================================================================


/// HWMultipartData for upload datas, eg: images/photos
public class HWMultipartData {
    /// The data to be encoded and appended to the form data.
    let data: Data
    /// Name to associate with the `Data` in the `Content-Disposition` HTTP header.
    let name: String
    /// Filename to associate with the `Data` in the `Content-Disposition` HTTP header.
    let fileName: String
    /// The MIME type of the specified data. (For example, the MIME type for a JPEG image is image/jpeg.) For a list of valid MIME types, see http://www.iana.org/assignments/media-types/. This parameter must not be `nil`.
    let mimeType: String
    
    
    /// Create HWMultipartDataModel
    /// - Parameters:
    ///   - data: The data to be encoded and appended to the form data.
    ///   - name: The name to be associated with the specified data.
    ///   - fileName: The filename to be associated with the specified data.
    ///   - mimeType: The MIME type of the specified data. eg: image/jpeg
    init(data: Data, name: String, fileName:String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        
    
    }

    // mimeType --> image/jpeg, image/png, image/gif,
    // see: https://www.cnblogs.com/fuqiang88/p/4618652.html
    
    // 中文说明一下，增加理解：
    // 当提交一张图片或一个文件的时候 name 可以随便设置，服务端直接能拿到，如果服务端需要根据name去取不同文件的时候
    // 则appendPartWithFileData 方法中的 name 需要根据form的中的name一一对应
    // 所以name的值，是需要跟后台服务端商量好的.
}

/// 常见数据类型的`MIME Type`
public enum HWDataMimeType: String {
    case JPEG = "image/jpeg"
    case PNG = "image/png"
    case GIF = "image/gif"
    case HEIC = "image/heic"
    case HEIF = "image/heif"
    case WEBP = "image/webp"
    case TIF = "image/tif"
    case JSON = "application/json"
}
