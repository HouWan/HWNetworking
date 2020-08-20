## 一.前言
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

## 二.使用方法A

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

## 三.使用方法B

3.1 结合`HWAPIProtocol`使用，这里新建一个`struct`去实现`HWAPIProtocol`:
```swift
struct APIItem: HWAPIProtocol {
    var url: String { API.DOMAIN + URLPath }  // 域名 + path
    let description: String
    let extra: String?
    var method: HWHTTPMethod

    private let URLPath: String  // URL的path

    init(_ path: String, d: String, e: String? = nil, m: HWHTTPMethod = .get) {
        URLPath = path
        description = d
        extra = e
        method = m
    }
}
```

3.2. 项目里面，写API的文件就可以设计为(模块化):
```swift
struct API {
    static var DOMAIN = "https://www.baidu.com/"

    // MARK: Home模块
    struct Home {
        static let homeIndex = APIItem("homeIndex", d: "首页数据")
        static let storeList = APIItem("homeIndex", d: "首页门店列表", m: .post)
    }

    // MARK: 圈子模块
    struct Social {
        static let socialIndex = APIItem("socialList", d: "圈子首页列表")
    }
}
```

3.3 网络请求方式:
```swift
// 1.不带参数
HN.fetch(API.Home.homeIndex).success { response in
    print(response)
}

// 2.加上参数
let p: [String: Any] = ["name": "ZhangSan", "age": 22]
HN.fetch(API.Home.homeIndex, parameters: p).success { response in
    print(response)
}

// 3.加上Header 和失败情况
let h = ["Referrer Policy": "no-referrer-when-downgrade"]
HN.fetch(API.Home.homeIndex, headers: h).success { response in
    print(response)
}.failed { error in
    print(error)
}
```

> 可能有人疑问，为什么接口要加一个`description`，这里解释一下:
> 1.在API文件里，能直接明白这接口是做什么的
> 2.在我项目里，有一个debug隐藏模块，可以看到所有的API请求情况，可以看到这个`description`
> 3.在debug模块里，不仅后台Java同事能通过`description`定位接口，测试同事也方便找接口

----
## 四.使用方法C
由于已经为`HWAPIProtocol`扩展了已实现`fetch()`方法，所以上面的请求可以简化为更高阶的方式:
```swift
// 1.不带参数
API.Me.meIndex.fetch().success { response in
    print("response -->", response)
}.failed { error in
    print("error -->", error)
}

API.Home.homeIndex.fetch(success: {response in
    print(response)
}, failed: {error in
    print(error)
})

// 2.加上参数
let p: [String: Any] = ["name": "ZhangSan", "age": 22]
API.Home.homeIndex.fetch(p, success: { response in
    print(response)
}) { error in
    print(error)
}

// 3.加上Header 和失败情况
let h = ["Referrer Policy": "no-referrer-when-downgrade"]
API.Home.homeIndex.fetch(p, headers: h, success: { response in
    print(response)
}) { error in
    print(error)
}
```
----

## 五.OC使用方法
OC的请求如下，具体可以看Demo，这里简单列举一个实例：
```c
NSString *url = @"http://game.gtimg.cn/images/lol/act/img/js/heroList/hero_list.js";
NSDictionary *dict = @{@"v": @(33)};

[HWNetworkingOC GET:url info:@"LOL英雄列表" parameters:dict success:^(id response) {
    NSLog(@"%@", response);
} failed:^(NSString *error) {
    NSLog(@"%@", error);
}];
```
----

## 六.思路？
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

将来要做的功能:
- [ ] 支持`closure`和`delegate`两种模式的回调方式
- [ ] 支持网络请求`URL`的`filter`，可以统一为网络请求加上一些参数，或者拦截请求结果
- [ ] 统一的`Header`设置


也欢迎大家把好的想法留言或者`git Issues`，因为我会在项目里使用这个类，所以后面如果有新的想法和功能，我都会更新维护的。

**Github地址**，[GitHub点我](https://github.com/HouWan/HWNetworking)或者复制下面链接：
<https://github.com/HouWan/HWNetworking>

> 从github上clone下以后，cd到目录`SwiftDemo`，执行`pod install`命令即可运行Demo
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

**PS**:最近我有跳槽的想法，有工作机会的老板，欢迎骚扰哦！北京呦！

**END。**
*我是小侯爷。*
*在魔都艰苦奋斗，白天是上班族，晚上是知识服务工作者。*
*如果读完觉得有收获的话，记得关注和点赞哦。*
*非要打赏的话，我也是不会拒绝的。*

### License

`HWNetworking` is released under the MIT license. See [LICENSE](https://github.com/HouWan/HWNetworking/blob/master/LICENSE) for details.
