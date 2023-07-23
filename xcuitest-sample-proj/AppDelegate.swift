//
//  AppDelegate.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 20.07.23.
//

import SwiftUI

@main
struct YourAppNameApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}

struct TabBarView: View {
    var body: some View {
        TabView {
            CarouselView()
                .tabItem {
                    Label("Carousel", systemImage: "star")
                }
            LoadingElementsView()
                .tabItem {
                    Label("Loading", systemImage: "star")
                }
            CameraPermissionsRequestView()
                .tabItem {
                    Label("Permissions", systemImage: "camera")
                }
        }
    }
}

struct CarouselView: View {
    @State private var isButtonVisible = true
    @State private var text: String = ""
    
    var body: some View {
        VStack {
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
        }
        
    }
    
    private func hideButtonAfterDelay() {
        // Set the button visibility to false after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            isButtonVisible = false
        }
    }
}

struct LoadingElementsView: View {
    @State private var visibleElements = 1
    private let totalElements = 5
    private let interval = 2.0 // In seconds
    
    var body: some View {
        List {
            ForEach(0..<visibleElements, id: \.self) { index in
                Text("Element \(index + 1)")
                    .accessibilityIdentifier("loaded-el")
            }
        }
        .onAppear {
            // Start the timer when the view appears
            Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
                if visibleElements < totalElements {
                    visibleElements += 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}
