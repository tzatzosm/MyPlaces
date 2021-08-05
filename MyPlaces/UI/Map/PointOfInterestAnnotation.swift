//
//  PointOfInterestAnnotation.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 4/8/21.
//

import Foundation
import MapKit

class PointOfInterestAnnotation: MKPointAnnotation, Comparable {
    var pointOfInterest: PointOfInterest
    
    init(with pointOfInterest: PointOfInterest) {
        self.pointOfInterest = pointOfInterest
        super.init()
        self.title = pointOfInterest.name
        self.subtitle = pointOfInterest.category
    }
    
    var glyphImage: UIImage? {
        return UIImage(named: pointOfInterest.imageName)
    }
    
    override var coordinate: CLLocationCoordinate2D {
        get {
            return pointOfInterest.coordinate
        }
        set { }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? PointOfInterestAnnotation else { return false }
        return self.pointOfInterest.id == object.pointOfInterest.id
    }
    
    static func < (lhs: PointOfInterestAnnotation, rhs: PointOfInterestAnnotation) -> Bool {
        return lhs.pointOfInterest.id < rhs.pointOfInterest.id
    }
}
