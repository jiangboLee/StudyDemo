//
//  MenuView.swift
//  CollectionCustomLayoutDemo
//
//  Created by ljb48229 on 2017/11/23.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func reloadCollectionViewDataWithTeamIndex(_ index: Int)
}

class MenuView: UICollectionReusableView {

    @IBAction func tappedButton(_ sender: UIButton) {
        
        delegate?.reloadCollectionViewDataWithTeamIndex(sender.tag)
    }
    var delegate: MenuViewDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        delegate = nil
    }
}





