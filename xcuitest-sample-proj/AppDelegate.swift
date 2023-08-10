//
//  AppDelegate.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 20.07.23.
//

import SwiftUI
import Sliders

@main
struct YourAppNameApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}

struct TabBarView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FirstScreenView()
                .tabItem {
                    Label("Carousel", systemImage: "star")
                }.tag(0)
            LoadingElementsView()
                .tabItem {
                    Label("Loading", systemImage: "star")
                }.tag(1)
            CameraPermissionsRequestView()
                .tabItem {
                    Label("Permissions", systemImage: "camera")
                }.tag(2)
            QueriesScreenView()
                .tabItem {
                    Label("Queries", systemImage: "star")
                }.tag(3)
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
