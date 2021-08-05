//
//  ListView.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 3/8/21.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.pointsOfInterest) { pointOfInterest in
                    ListCell(imageName: pointOfInterest.imageName,
                             name: pointOfInterest.name,
                             category: pointOfInterest.category,
                             distance: pointOfInterest.distance)
                }
            }
        }
        .navigationBarItems(leading: Button("Filters", action: {
            viewModel.showFilters = true
        }), trailing: Button("Map", action: {
            print("viewModel.displayMode = .map")
            viewModel.displayMode = .map
        }))
        .navigationTitle("Nearby places")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(viewModel: HomeViewModel())
    }
}
