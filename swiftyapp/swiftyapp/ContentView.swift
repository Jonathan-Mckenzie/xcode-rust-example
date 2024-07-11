//
//  ContentView.swift
//  swiftyapp
//
//  Created by Jonathan McKenzie on 7/9/24.
//

import SwiftUI
import RustyLib

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(rustHello())
            Text(String(rustAdd(a: 10, b: 32)))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
