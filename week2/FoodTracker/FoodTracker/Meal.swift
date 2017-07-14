//
//  Meal.swift
//  FoodTracker
//
//  Created by 임성훈 on 2017. 7. 9..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // 이름 비어있거나 등급이 음수 또는 5초과면 nil 반환
        guard !name.isEmpty else {
            return nil
        }
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // 프로퍼티 초기화
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
