//
//  PetCardStore.swift
//  CardController(卡片转场动画)
//
//  Created by ljb48229 on 2018/1/29.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

struct PetCardStore {
    
    static let defultPets: [PetCard] = {
       return parsePets()
    }()
    
    private static func parsePets() -> [PetCard] {
        guard let fileUrl = Bundle.main.url(forResource: "Pets", withExtension: "plist") else { return [] }
        
        do {
            let petData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            let pets = try PropertyListDecoder().decode([PetCard].self, from: petData)
            return pets
        } catch  {
            print(error)
            return []
        }
    }
}
