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
            
            DummyPage2View()
                .tabItem {
                    Label("Dummy Page 2", systemImage: "star")
                }
            
            DisappearButtonView()
                .tabItem {
                    Label("Disappear", systemImage: "star")
                }
        }
    }
}

struct CarouselView: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(1...10, id: \.self) { index in
                    // Load each carousel item lazily
                    CarouselItemView(item: index)
                }
            }
            .padding()
        }
        .accessibilityIdentifier("carousel-view")
    }
}

struct DummyPage2View: View {
    var body: some View {
        // Your content for the third dummy page
        Text("Dummy Page 3")
    }
}

struct DisappearButtonView: View {
    @State private var isButtonVisible = true
    
    var body: some View {
        VStack {
            if isButtonVisible {
                Button("Disappearing button") {
                    // Handle the action when the button is tapped
                    hideButtonAfterDelay()
                }
                .foregroundColor(.white) // Text color
                .padding()
                .frame(width: 200, height: 50) // Set exact width and height
                .background(Color.blue) // Button background color
                .cornerRadius(12) // Rounded re
                .accessibilityIdentifier("disappearing-button")
            }
        }
        .padding()
    }
    
    private func hideButtonAfterDelay() {
        // Set the button visibility to false after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            isButtonVisible = false
        }
    }
}
