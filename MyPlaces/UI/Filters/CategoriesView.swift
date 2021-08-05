//
//  CategoriesView.swift
//  MyPlaces2
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 4/8/21.
//

import SwiftUI

struct CategoriesView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var categories: [String]
    @Binding var selectedCategories: [String]
    
    var body: some View {
        VStack {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    if let index = selectedCategories.firstIndex(of: category) {
                        selectedCategories.remove(at: index)
                    } else {
                        selectedCategories.append(category)
                    }
                }, label: {
                    Text(category)
                        .font(.headline)
                        .padding()
                        .padding(.horizontal, 8)
                        .overlay(
                            Capsule()
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .background(
                            Capsule()
                                .fill(selectedCategories.contains(category) ? Color.orange : Color.clear,
                                      style: FillStyle())
                        )
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                })
            }
        }
    }
    
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categories: .constant(["Sights", "Nightlife", "Restaurant", "Shopping"]),
                       selectedCategories: .constant(["Sights", "Restaurant"]))
    }
}
