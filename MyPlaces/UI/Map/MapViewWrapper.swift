//
//  Map.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 4/8/21.
//

import SwiftUI

struct MapViewWrapper: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            MapView(region: $viewModel.region,
                    pois: $viewModel.pointsOfInterest,
                    selectedPOI: $viewModel.selectedPointOfInterest) { region in
                viewModel.userMovedRegion = region
            }
        }
        .navigationBarItems(leading: Button("Filters", action: {
            viewModel.showFilters = true
        }), trailing: Button("List", action: {
            print("viewModel.displayMode = .map")
            viewModel.displayMode = .list
        }))
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MapViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWrapper(viewModel: HomeViewModel())
    }
}
