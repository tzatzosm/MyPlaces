//
//  DisplayMode.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 4/8/21.
//

import Foundation

enum DisplayMode: Hashable {
    case list
    case map
    
    var isMap: Bool {
        get {
            switch self {
            case .map: return true
            default: return false
            }
        }
        set {
            self = .map
        }
        
    }
    
    var isList: Bool {
        get {
            switch self {
            case .list: return true
            default: return false
            }
        }
        set {
            self = .list
        }
    }
    
}
