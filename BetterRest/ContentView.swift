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
                    VStack {
                        Text("When do you want to wake up?")
                            .font(.headline)
                            .padding()
                        DatePicker(
                            "Please enter a time", selection: $wakeUp,
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(.thinMaterial)
                    .overlay(
                        Rectangle().stroke(style: StrokeStyle(lineWidth: 1)))
                }
                Spacer()
                Section("Sleep Amount") {
                    VStack {
                        Text("Desired amount of sleep?")
                            .font(.headline)
                            .padding()
                        Stepper(
                            "\(sleepAmount.formatted()) hours",
                            value: $sleepAmount,
                            in: 4...12, step: 0.25
                        )
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(.thinMaterial)
                    .overlay(
                        Rectangle().stroke(style: StrokeStyle(lineWidth: 1)))
                }
                .padding(.horizontal)
                Spacer()
                Section("Coffee Intake") {
                    VStack {
                        Text("Daily Coffee Intake")
                            .font(.headline)
                            .padding()
                        Stepper(
                            "\(coffeeAmount) cups", value: $coffeeAmount,
                            in: 1...20
                        )
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(.thinMaterial)
                    .overlay(Rectangle().stroke(style: StrokeStyle(lineWidth: 1)))
                }
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle(Text("BetterRest"))
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }
        Spacer()
        Spacer()
        Spacer()
    }
}

func calculateBedtime() {

}

#Preview {
    ContentView()
}
