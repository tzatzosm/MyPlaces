//
//  LocationAccessErrorView.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 3/8/21.
//

import SwiftUI

struct LocationAccessErrorView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("This application requires location access.")
                .padding(.bottom, 10)
            Button("Settings") {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl,
                                              completionHandler: nil)
                }
            }
            Spacer()
        }
    }
}

struct LocationAccessErrorView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAccessErrorView()
    }
}
