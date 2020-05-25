对于iOS开发者，应该没有不知道`AFNetworking`的！它是一个用OC语言写的网络库，对于`AFNetworking`有很多著名的二次封装，比如猿题库团队的开源库`YTKNetwork`，它将`AFNetworking`封装成抽象父类，然后根据每个不同的网络请求，都编写不同的子类，子类继承父类，来实现请求业务（OOP思想设计）。

对于Swift开发，优雅的网络开发框架`Alamofire`当是不二选择，`Alamofire`是建立在`NSURLSession`上的封装，可以直接使用`Alamofire`进行网络请求，但是我们项目中往往需要一些“项目化”设置，所以习惯二次封装。在Swift开源社区，对`Alamofire`二次封装最有名的当属`Moya`，它在底层将`Alamofire`进行封装，对外提供更简洁的接口供开发者调用(POP思想设计).

> `Alamofire`地址: <https://github.com/Alamofire/Alamofire>
> `Moya`地址: <https://github.com/Moya/Moya>

不过似乎在大型项目，比如使用`Moya+RxSwift+MVVM`才能发挥`Moya`的威力，所以对中小项目，大都会自己简单对`Alamofire`封装下使用，网上搜索一下，封装之后的使用方法几乎都是下面这种方式:

```swift
NetworkTools.request(url: "api", parameters:p, success: { (response) in
    // TODO...
}) { (error) in
    // TODO...
}
```

这种应该是受OC的影响，方法里面跟着2个`Block`回调的思路。但在Swift里面就是两个逃逸尾随闭包`@escaping closure`，虽然语法没问题，但是我感觉怪怪的，特别是闭包里面代码一多起来，`{()}{()}`大括号看的晕晕的。

我受`PromiseKit`和`JQuery`启发，进行了`点`语法封装，使用方法如下:
> `PromiseKit`是`iOS/MacOS`中一个用来处理异步编程的框架。可以直接配合`Alamofire`或者`AFNetworking`进行处理，功能很强大!
> GitHub: <https://github.com/mxcl/PromiseKit>

```swift
// 进行一个请求，不管失败情况
HN.POST(url: url, parameters: p, datas: datas).success { (response) in
    debugPrint("success: \(response)")
}

// 进行一个请求，处理成功和失败
HN.GET(url: url, parameters: p).success { (response) in
    debugPrint("success: \(response)")
}.failed { (error) in
    debugPrint("failed: \(error)")
}

// 上传图片
HN.POST(url: url, parameters: p, datas: datas).progress { (progress) in
    debugPrint("progress: \(progress.fractionCompleted)")
}.success { (response) in
    debugPrint("success: \(response)")
}.failed { (error) in
    debugPrint("failed: \(error)")
}
```

正如上面代码所示，成功和失败都是使用`点`语法进行回调，清晰明了，甚至你可以不管成功和失败，只发送一个请求:
```swift
HN.GET(url: "api")
```

----

设计思路其实很简单，首先是一个单例，用于持有`Alamofire.Session`和每个请求对象，顺便定义几个回调
```swift
/// Closure type executed when the request is successful
public typealias HNSuccessClosure = (_ JSON: Any) -> Void
/// Closure type executed when the request is failed
public typealias HNFailedClosure = (_ error: Any) -> Void
/// Closure type executed when monitoring the upload or download progress of a request.
public typealias HNProgressHandler = (Progress) -> Void

public class HWNetworking {
    /// For singleton pattern
    public static let shared = HWNetworking()
    /// TaskQueue Array for (`Alamofire.Request` & callback)
    private var taskQueue = [HWNetworkRequest]()
    /// `Session` creates and manages Alamofire's `Request` types during their lifetimes.
    var sessionManager: Alamofire.Session!
}
```

把每个请求封装成对象，调用对象的`success(...)`方法和`failed(...)`等，获得这个请求的成功和失败回调，回调之后，销毁对象即可.
```swift
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
    public func success(_ closure: @escaping HNSuccessClosure) -> Self {
        successHandler = closure
        return self
    }
    
    /// Adds a handler to be called once the request has finished.
    @discardableResult
    public func failed(_ closure: @escaping HNFailedClosure) -> Self {
        failedHandler = closure
        return self
    }
}
```

核心的请求方法如下：
```swift
extension HWNetworking {
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
}
```

再封装几个常用的POST和Get快捷方法：
```swift
/// Shortcut method for `HWNetworking`
extension HWNetworking {
    @discardableResult
    public func POST(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> HWNetworkRequest {
        request(url: url, method: .post, parameters: parameters, headers: nil)
    }

    /// Creates a GET request
    @discardableResult
    public func GET(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> HWNetworkRequest {
        request(url: url, method: .get, parameters: parameters, headers: nil)
    }
}
```

大致的思路就如上面贴出的关键代码，限于篇幅，这里不贴完整的代码了，可以直接去Github上`clone`下来看看，实现的大致功能如下:
- [x] 常规的POST/GET
- [x] 网络状态监听和通知
- [x] 上传图片的封装(单张或者多张)
- [ ] 下载文件(没有做，我这项目里没有这样的需求，不过方法留着了，自行扩展即可)

将来想做的功能:
- [ ] 支持`closure`和`delegate`两种模式的回调方式
- [ ] 支持网络请求`URL`的`filter`，可以统一为网络请求加上一些参数，或者拦截请求结果


也欢迎大家把好的想法留言或者`git Issues`，因为我会在项目里使用这个类，所以后面如果有新的想法和功能，我都会更新维护的。

**Github地址**，[GitHub点我](https://github.com/HouWan/HWNetworking)或者复制下面链接：
<https://github.com/HouWan/HWNetworking>


----

关于`尾随闭包`，可能有同学说，那系统很多API这么使用的，比如:
```swift
UIView.animate(withDuration: 1, animations: {
    // TODO...
}) { (finished) in
    // TODO...
}
```

这个看大家习惯了，不过在最新的`Swift 5.3`中，针对这块多个尾随闭包有了新的语法糖：
```swift
// old Swift3
UIView.animate(withDuration: 0.3, animations: {
    self.view.alpha = 0
}, completion: { _ in
    self.view.removeFromSuperview()
})
// still old  Swift4/5
UIView.animate(withDuration: 0.3, animations: {
    self.view.alpha = 0
}) { _ in
    self.view.removeFromSuperview()
}
// new swift 5.3
UIView.animate(withDuration: 0.3) {
    self.view.alpha = 0
} completion: { _ in
    self.view.removeFromSuperview()
}
```

### License

`HWNetworking` is released under the MIT license. See [LICENSE](https://github.com/HouWan/HWNetworking/blob/master/LICENSE) for details.
