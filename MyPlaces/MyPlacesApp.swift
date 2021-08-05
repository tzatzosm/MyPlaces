//
//  MyPlacesApp.swift
//  MyPlaces
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 4/8/21.
//

import SwiftUI

@main
struct MyPlacesApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
        }
    }
}
