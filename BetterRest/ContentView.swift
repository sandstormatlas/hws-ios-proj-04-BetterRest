//
//  ContentView.swift
//  BetterRest
//
//  Created by Jason Angus on 4/4/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Section("Wake Time") {
                    Text("When do you want to wake up?")
                        .font(.headline)
                        .padding()
                    DatePicker(
                        "Please enter a time", selection: $wakeUp,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
