//
//  SocietyListCell.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/10.
//  Copyright © 2020 HouWan. All rights reserved.
//

import UIKit

class SocietyListCell: UITableViewCell {

    func show(model: CoachListModel) {
        // TODO...
    }

    // ============================================================================
    // MARK: - Initialization
    // ============================================================================
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createAndConfigUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAndConfigUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        contentView.isExclusiveTouch = true
        
        contentView.layer.borderColor = UIColor.random.cgColor
        contentView.layer.borderWidth = 0.5
    }
}
