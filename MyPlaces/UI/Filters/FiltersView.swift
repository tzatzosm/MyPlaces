import SwiftUI

struct FiltersView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            if viewModel.displayMode.isList {
                Text("Radius")
                    .font(.title)
                
                VStack {
                    Slider(value: $viewModel.radius, in: 1...20, step: 1)
                        .padding()
                    Text("\(viewModel.radius, specifier: "%.0f km" )")
                }.padding()
            }
            
            Text("Categories")
                .padding()
                .font(.title)
            CategoriesView(categories: $viewModel.categories,
                           selectedCategories: $viewModel.selectedCategories)
            
            Spacer()
            Button("Apply") {
                viewModel.showFilters = false
                viewModel.fetchNearbyPlaces()
            }
            .font(.title)
            .padding()
        }
        .padding(.top, 40)
        
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(viewModel: HomeViewModel())
    }
}
