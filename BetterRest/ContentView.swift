//
//  ContentView.swift
//  BetterRest
//
//  Created by Jason Angus on 4/4/2025.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Wake Time") {
                    VStack(alignment: .leading, spacing: 0) {
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
                .padding(.horizontal)

                Section("Sleep Amount") {
                    VStack(alignment: .leading, spacing: 0) {
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

                Section("Coffee Intake") {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Daily Coffee Intake")
                            .font(.headline)
                            .padding()
                        Stepper(
//                            "\(coffeeAmount) cup\(coffeeAmount == 1 ? "" : "s")",
                            // Use swift format string to inflect "cup" based on coffeeAmount
                            "^[\(coffeeAmount) cup](inflect: true)",
                            value: $coffeeAmount,
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
