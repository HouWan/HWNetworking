//
//  MeViewController.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/7.
//  Copyright © 2020 HouWan. All rights reserved.
//

import UIKit

class MeViewController: DBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的"
        
        let a = UILabel(font: SemiboldFont(25), color: UIColor.purple)
        a.text = "天使😇天使"
        a.frame = CGRect(x: 10, y: 100, width: 190, height: 55)
        view.addSubview(a)
    }

}
