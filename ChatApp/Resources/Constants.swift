//
//  Constants.swift
//  ChatApp
//
//  Created by Justine Tabin on 7/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

struct API {
    static var baseURL = "http://13.212.2.125:8000"
}

struct Fonts {
    static func small(weight: UIFont.Weight = .regular) -> UIFont {
        UIFont.systemFont(ofSize: 14, weight: weight)
    }
    
    static func medium(weight: UIFont.Weight = .regular) -> UIFont {
        UIFont.systemFont(ofSize: 20, weight: weight)
    }
    
    static func large(weight: UIFont.Weight = .regular) -> UIFont {
        UIFont.systemFont(ofSize: 26, weight: weight)
    }
}

struct Colors {
    static var lightGray = UIColor.systemGray6
}
