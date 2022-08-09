//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Jan Andrzejewski on 09/08/2022.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        Text("Welcome to SnowSeeker!")
            .font(.largeTitle)
        
        Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
            .foregroundColor(.secondary)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
