//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Jan Andrzejewski on 09/08/2022.
//

import SwiftUI

struct ResortView: View {
    let resort: Resort
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    @EnvironmentObject var favorites: Favorites
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                        .overlay(ImageOverlay(credit: resort.imageCredit), alignment: .bottomLeading)
                
                HStack {
                    if sizeClass == .compact && typeSize > .large {
                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                
                Group {
                    
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            
            Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                if favorites.contains(resort) {
                    feedback.prepare()
                    favorites.remove(resort)
                    feedback.notificationOccurred(.warning)
                } else {
                    feedback.prepare()
                    favorites.add(resort)
                    feedback.notificationOccurred(.success)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
    }
}

// view for the image credit
struct ImageOverlay: View {
    let credit: String
    var body: some View {
        ZStack {
            Text("Photo by \(credit)")
                .font(.callout)
                .padding(4)
                .foregroundColor(.white)
        }
        .background(Color.black)
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(4)
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResortView(resort: Resort.example)
        }
        .environmentObject(Favorites())
    }
}
