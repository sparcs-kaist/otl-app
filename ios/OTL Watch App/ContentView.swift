//
//  ContentView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 10/22/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WatchViewModel()
    
    @State private var loginState: Bool = true
    
    var body: some View {
        if loginState {
            WeeklyTableView(loginState: self.$loginState)
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
