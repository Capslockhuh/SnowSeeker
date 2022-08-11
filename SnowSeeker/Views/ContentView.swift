//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Jan Andrzejewski on 08/08/2022.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var searchText = ""
    
    @State private var sortSelection = 0
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
    @StateObject var favorites = Favorites()
    
    @State private var sorted: [Resort] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("Sort type")) {
                    Picker(selection: $sortSelection, label: Text("Sort")) {
                        Text("Default").tag(0)
                        Text("Alphabetical").tag(1)
                        Text("Country").tag(2)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing])
                .onChange(of: sortSelection) { _ in
                    self.sortResorts()
                }
                
            List(sorted) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                            .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            
            WelcomeView()
        }
        .environmentObject(favorites)
    }
    
     func sortResorts() {
        switch sortSelection {
        case 1:
            sorted = filteredResorts.sorted { $0.name < $1.name }
        case 2:
            sorted = filteredResorts.sorted { $0.country < $1.country }
        default:
            sorted = filteredResorts
            
        }
        
    }

}

/* This extension disables slide over view in landscape on bigger iPhones and iPads.
    To use it add .phoneOnlyStackNavigationView() modifier to the navigationView above.
 */
extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
