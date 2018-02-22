//
//  AnimalCell.swift
//  SlideDemo(抽屉左滑右滑)
//
//  Created by ljb48229 on 2018/2/22.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class AnimalCell: UITableViewCell {

    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var imageCreatorLabel: UILabel!
    
    func configureForAnimal(_ animal: Animal) {
        animalImageView.image = animal.image
        imageNameLabel.text = animal.title
        imageCreatorLabel.text = animal.creator
    }
}
