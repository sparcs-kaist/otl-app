//
//  ContentView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 10/22/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WatchViewModel()
    @AppStorage("sessionID") var sessionID: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(sessionID)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
