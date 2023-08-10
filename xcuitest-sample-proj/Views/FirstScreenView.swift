//
//  CarouselView.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 10.08.23.
//

import SwiftUI

struct FirstScreenView: View {
    @StateObject var viewModel = ArgumentTextViewModel()
    @State private var isButtonVisible = true
    @State private var text: String = ""
    @State var sliderValue: Double = .zero
    @State var selectedDate = Date()
    @State var selectedPickerValue = "None"
    @State private var showingAlert = false
    
    var body: some View {
        ScrollView {
            let pickerValues = ["None", "Little", "Medium", "Normal", "More", "Many"]
            Picker("", selection: $selectedPickerValue) {
                ForEach(pickerValues, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            .accessibilityIdentifier("picker")
            .border(.black)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(1...10, id: \.self) { index in
                        // Load each carousel item lazily
                        CarouselItemView(item: index)
                    }
                }
                .padding()
                .frame(height: 150)
            }
            .accessibilityIdentifier("carousel-view")
            
            VStack {
                if isButtonVisible {
                    Button("Disappearing button") {
                        // Handle the action when the button is tapped
                        hideButtonAfterDelay()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .accessibilityIdentifier("disappearing-button")
                }
            }
            
            TextFieldWrapper(text: $text)
                .padding()
                .frame(width: 200, height: 50)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityIdentifier("text-field")
            
            Text("Argument:\(viewModel.displayText)")
                .foregroundColor(.gray)
                .padding(.top, 8)
                .accessibilityIdentifier("argument-text")
                .onAppear {
                    // Check if the launch arguments contain the specific argument you provided
                    if CommandLine.arguments.contains("-showCustomText") {
                        // Perform any action based on the launch argument, e.g., update ViewModel
                        viewModel.displayText = "Custom"
                    }
                }
            
            Slider(value: $sliderValue, in: 0...1)
                .frame(width: 300, height: 50)
                .accessibilityIdentifier("slider")
            
            Spacer()
                .frame(height: 30)
            
            Button("Show Alert") {
                showingAlert = true
            }
            .foregroundColor(.white)
            .padding()
            .frame(width: 200, height: 50)
            .background(Color.blue)
            .cornerRadius(12)
            .accessibilityIdentifier("alert-button")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("This is an alert"), message: Text("Please take care!"), primaryButton: .default(Text("Accept")), secondaryButton: .cancel(Text("Close")))
            }
        }
    }
    
    private func hideButtonAfterDelay() {
        // Set the button visibility to false after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            isButtonVisible = false
        }
    }
}

class ArgumentTextViewModel: ObservableObject {
    @Published var displayText: String = "Default"
}
