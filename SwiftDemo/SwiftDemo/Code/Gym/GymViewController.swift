//
//  GymViewController.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/7.
//  Copyright © 2020 HouWan. All rights reserved.
//

import UIKit

class GymViewController: DBaseVC, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    
    private let CELL_CRI = "CellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndConfigUI()
    }
    
    func createAndConfigUI() {
        title = "健身房"
        
        let h = kScreenHeight - kNavigatioHeight - kTabBarHeight
        let r = CGRect(x: 0, y: kNavigatioHeight, width: kScreenWidth, height: h)
        
        tableView = UITableView(frame: r, style: .plain);
        tableView.backgroundColor = theme_tint_A_color
        // tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_CRI)
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
    }
}


///  UITableViewDelegate
extension GymViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint(indexPath)
    }
}

/// UITableViewDataSource
extension GymViewController {
    
    @available(iOS 2.0, *)
    // Default is 1 if not implemented
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: CELL_CRI, for: indexPath)
        
        c.selectionStyle = .none
        c.textLabel?.textColor = theme_text_A_color
        c.textLabel?.font = MediumFont(15)
        c.textLabel?.text = "精品私教课"
        
        return c
    }
    
    
}
