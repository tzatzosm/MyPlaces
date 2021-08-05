//
//  HomeView.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 3/8/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                if viewModel.authorisationStatus == .denied {
                    LocationAccessErrorView()
                } else {
                    TabView(selection: $viewModel.displayMode,
                            content:  {
                                ListView(viewModel: viewModel)
                                    .tag(DisplayMode.list)
                                
                                MapViewWrapper(viewModel: viewModel)
                                    .tag(DisplayMode.map)
                            })
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
        }.sheet(isPresented: $viewModel.showFilters, content: {
            FiltersView(viewModel: viewModel)
        })
        .onReceive(viewModel.$authorisationStatus, perform: { status in
            print("status is \(status.rawValue)")
            switch status {
            case .notDetermined:
                viewModel.requestAuthorisation()
            case .authorizedWhenInUse:
                viewModel.fetchNearbyPlaces()
            default:
                break
            }
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
