//
//  ContentView.swift
//  OTL Watch App
//
//  Created by Soongyu Kwon on 10/22/23.
//

import SwiftUI

@available(iOS 17.0, *)
struct ContentView: View {
    @State private var loginState: Bool = true
    
    var body: some View {
        if loginState {
            WeeklyTableView(loginState: self.$loginState)
        } else {
            LoginView()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ContentView()
}
