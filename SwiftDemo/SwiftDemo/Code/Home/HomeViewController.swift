//
//  HomeViewController.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/7.
//  Copyright © 2020 HouWan. All rights reserved.
//

import UIKit

class HomeViewController: DBaseVC {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "首页"
        
        let a = UILabel(font: SemiboldFont(16), color: UIColor.blue)
        a.text = "用法直接看`HomeViewController`类即可"
        a.frame = CGRect(x: 10, y: 100, width: view.width, height: 55)
        view.addSubview(a)
        
        
        // 开始网络状态监测
        // 由于可能多个地方需要知道网络状态，所以添加通知`kNetworkStatusNotification`即可
        // 在通知回调方法里面，判断`HN.networkStatus`即可
        HN.startMonitoring()
    }
    
    // get请求
    func get() {
        let url = "https://demo.xx.com/get/"
        let p: [String : Any] = ["name": "demo", "age": 18]
        
        HN.GET(url: url, parameters: p).success { (response) in
            // TODO...
        }.failed { (error) in
            // TODO...
        }
    }
    
    // post请求
    func post() {
        let url = "https://demo.xx.com/get/"
        let p: [String : Any] = ["name": "demo", "age": 18]
        
        HN.POST(url: url, parameters: p).success { (response) in
            // TODO...
        }.failed { (error) in
            // TODO...
        }
    }
    
    // 上传图片
    func photo() {
        let url = "https://demo.xx.com/get/"
        let p: [String : String] = ["name": "demo", "age": "18"]
        
        // 假设这里有2个照片，转为data，一般是选取相册里面的，可能还要压缩
        let d1_png = (UIImage(named: "xxxx.png")?.pngData())!
        let d2_jpg = (UIImage(named: "xxxx.jpg")?.jpegData(compressionQuality: 1))!
        
        // 图片的`MIME Type`可以使用`SDWebImage`获得
        let datas = [HWMultipartData(data: d1_png, name: "headurl", fileName: "1.png",
                                     mimeType: HWDataMimeType.PNG.rawValue),
                     HWMultipartData(data: d2_jpg, name: "headurl", fileName: "2.jpg",
                                     mimeType: HWDataMimeType.JPEG.rawValue)]
        
        HN.POST(url: url, parameters: p, datas: datas).progress { (progress) in
            debugPrint("progress: \(progress.fractionCompleted)")
        }.success { (response) in
            debugPrint("success: \(response)")
        }.failed { (error) in
            debugPrint("failed: \(error)")
        }
    }
}
