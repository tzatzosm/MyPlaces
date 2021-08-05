//
//  MapView.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 4/8/21.
//

import SwiftUI

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    typealias UserDidMoveRegion = (MKCoordinateRegion) -> ()
    
    @Binding var region: MKCoordinateRegion
    @Binding var pois: [PointOfInterest]
    @Binding var selectedPOI: PointOfInterest?
    var userDidMoveRegion: UserDidMoveRegion?
    
    init(region: Binding<MKCoordinateRegion>,
         pois: Binding<[PointOfInterest]>,
         selectedPOI: Binding<PointOfInterest?>,
         userDidMoveRegion: UserDidMoveRegion? = nil) {
        self._region = region
        self._pois = pois
        self._selectedPOI = selectedPOI
        self.userDidMoveRegion = userDidMoveRegion
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        print("updateUIView")
        // Update region
        view.setRegion(region, animated: true)
        // Update MapView annotations
        let annotations = self.pois.map { PointOfInterestAnnotation(with: $0) }
        if let mapAnnotations = view.annotations.filter({ !($0 is MKUserLocation) }) as? [PointOfInterestAnnotation],
           !annotations.containsSameElements(as: mapAnnotations) {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
            if let selectedPOI = self.selectedPOI,
               let annotation = annotations.first(where: { $0.pointOfInterest.id == selectedPOI.id }) {
                view.selectAnnotation(annotation, animated: false)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var nextRegionChangeIsFromUserInteraction = false
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            print("mapView.regionWillChangeAnimated")
            nextRegionChangeIsFromUserInteraction = false
            if let view = mapView.subviews.first, let gestureRecognizers = view.gestureRecognizers {
                for gestureRecognizer in gestureRecognizers {
                    switch gestureRecognizer.state {
                    case .began, .cancelled, .failed, .ended:
                        nextRegionChangeIsFromUserInteraction = true
                    default:
                        break
                    }
                }
            }
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print("mapView.DidChangeVisibleRegion")
            parent.region = mapView.region
            if nextRegionChangeIsFromUserInteraction, let userDidMoveRegion = parent.userDidMoveRegion {
                userDidMoveRegion(mapView.region)
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? PointOfInterestAnnotation else { return nil }
            let identifier = "amadeusPOIAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            annotationView?.displayPriority = .required
            annotationView?.annotation = annotation
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = annotation.glyphImage
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? PointOfInterestAnnotation else { return }
            parent.selectedPOI = annotation.pointOfInterest
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            guard let _ = view.annotation as? PointOfInterestAnnotation else { return }
            parent.selectedPOI = nil
        }
        
    }
    
}
