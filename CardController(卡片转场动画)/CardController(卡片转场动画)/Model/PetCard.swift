//
//  PetCard.swift
//  CardController(卡片转场动画)
//
//  Created by ljb48229 on 2018/1/29.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

struct PetCard: Decodable {
    let name: String
    let description: String
    let image: UIImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        let imageName = try container.decode(String.self, forKey: .image)
        image = UIImage(named: imageName)!
    }
}
