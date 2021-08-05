//
//  HomeViewModel.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 3/8/21.
//

import Foundation
import MapKit
import Combine
import Amadeus
import SwiftyJSON

class HomeViewModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let amadeus = Amadeus(client_id: "YOUR_CLIENT_ID_HERE",
                                  client_secret: "YOUR_CLIENT_SECRET_HERE",
                                  environment: ["logLevel" : "debug",
                                                "hostname": "production"])
    
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    @Published var location: CLLocationCoordinate2D? = nil
    
    @Published var displayMode = DisplayMode.list
    @Published var pointsOfInterest = [PointOfInterest]()
    @Published var selectedPointOfInterest: PointOfInterest? = nil
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var userMovedRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    @Published var radius: Float = 1
    @Published var categories = ["Sights", "Nightlife", "Restaurant", "Shopping"]
    @Published var selectedCategories: [String] = []
    @Published var showFilters: Bool = false
    
    private var disposables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        $userMovedRegion
            .dropFirst()
            // This is a continuous event
            // we only need the last value with a 2 minute window
            .debounce(for: .seconds(2),
                      scheduler: DispatchQueue.main)
            .sink { region in
                self.fetchPlaces(for: region)
            }.store(in: &disposables)
    }
    
    func requestAuthorisation() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchNearbyPlaces() {
        guard let location = self.locationManager.location?.coordinate else { return }
        var params = ["latitude": "\(location.latitude)",
                      "longitude": "\(location.longitude)",
                      "radius": "\(Int(radius))"]
        if categories.count > 0 {
            params["categories"] = categories.joined(separator: ",")
        }
        self.amadeus.referenceData.locations.pointsOfInterest.get(params: params) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.updatePois(response: response, zoomToRegion: true, location: location)
                }
            case .failure(let error):
                print("Error fetching nearby places - \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchPlaces(for region: MKCoordinateRegion) {
        guard let location = self.locationManager.location?.coordinate else { return }
        let north = region.center.latitude + (region.span.latitudeDelta / 2.0)
        let west = region.center.longitude - (region.span.longitudeDelta / 2.0)
        let south = region.center.latitude - (region.span.latitudeDelta / 2.0)
        let east = region.center.longitude + (region.span.longitudeDelta / 2.0)
        var params = ["north": "\(north)",
                      "west": "\(west)",
                      "south": "\(south)",
                      "east": "\(east)"]
        if categories.count > 0 {
            params["categories"] = categories.joined(separator: ",")
        }
        self.amadeus.referenceData.locations.pointsOfInterest.bySquare.get(params: params) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.updatePois(response: response, zoomToRegion: false, location: location)
                }
            case .failure(let error):
                print("Error fetching places for region - \(error.localizedDescription)")
            }
        }
    }
    
    private func updatePois(response: Response, zoomToRegion: Bool, location: CLLocationCoordinate2D) {
        // Update PointsOfInterest
        var pointsOfInterest = self.pointsOfInterest
        for pointOfInterest in response.data.arrayValue {
            let coordinate = CLLocationCoordinate2D(latitude: pointOfInterest["geoCode"]["latitude"].doubleValue,
                                                    longitude: pointOfInterest["geoCode"]["longitude"].doubleValue)
            // Calculate distance from your location in meters
            let locationFrom = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let locationTo = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let distance = locationTo.distance(from: locationFrom)
            let pointOfInterest = PointOfInterest(id: pointOfInterest["id"].stringValue,
                                                  name: pointOfInterest["name"].stringValue,
                                                  category: pointOfInterest["category"].stringValue,
                                                  coordinate: coordinate,
                                                  distance: distance)
            // Dont add the same point of interest twice in the list
            if !self.pointsOfInterest.contains(where: { $0.id == pointOfInterest.id }) {
                pointsOfInterest.append(pointOfInterest)
            }
            
        }
        // Update our model
        self.pointsOfInterest = pointsOfInterest.sorted(by: { $0.distance < $1.distance })
        
        if zoomToRegion {
            // Find mapRect for pois
            var mapRect = MKMapRect.null
            self.pointsOfInterest.forEach { pointOfInterest in
                let mapPoint = MKMapPoint(pointOfInterest.coordinate)
                mapRect = mapRect.union(MKMapRect(x: mapPoint.x,
                                                  y: mapPoint.y,
                                                  width: 0,
                                                  height: 0))
            }
            self.region = MKCoordinateRegion(mapRect)
        }
    }
    
}

extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        self.location = location
    }
}
