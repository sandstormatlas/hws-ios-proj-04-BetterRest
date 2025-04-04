//
//  ContentView.swift
//  BetterRest
//
//  Created by Jason Angus on 4/4/2025.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

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
                    .overlay(
                        Rectangle().stroke(style: StrokeStyle(lineWidth: 1)))
                }
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle(Text("BetterRest"))
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Ok") {}
        } message: {
            Text(alertMessage)
        }
        Spacer()
        Spacer()
        Spacer()
    }

    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents(
                [.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(
                wake: Double(hour + minute), estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is "
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            // Some error takes us here..
            alertTitle = "Error"
            alertMessage = "Something went wrong calculating your bedtime."
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
