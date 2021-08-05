//
//  PointOfInterest.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 4/8/21.
//

import Foundation
import MapKit

struct PointOfInterest: Identifiable {
    let id: String
    let name: String
    let category: String
    let coordinate: CLLocationCoordinate2D
    let distance: Double
    
    var imageName: String {
        switch category {
        case "SIGHTS": return "monument"
        case "NIGHTLIFE": return "nightlife"
        case "RESTAURANT": return "restaurant"
        case "SHOPPING": return "shopping"
        default: return "placeholder"
        }
    }
}

