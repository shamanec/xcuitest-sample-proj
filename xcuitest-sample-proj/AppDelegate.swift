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
            DummyPage1View()
                .tabItem {
                    Label("Dummy Page 1", systemImage: "star")
                }
                .accessibilityIdentifier("DummyPage1Tab")
            
            DummyPage2View()
                .tabItem {
                    Label("Dummy Page 2", systemImage: "heart")
                }
                .accessibilityIdentifier("DummyPage2Tab")
            
            DummyPage3View()
                .tabItem {
                    Label("Dummy Page 3", systemImage: "square")
                }
                .accessibilityIdentifier("DummyPage3Tab")
        }
    }
}

struct DummyPage1View: View {
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
       }
}

struct DummyPage2View: View {
    var body: some View {
        // Your content for the second dummy page
        Text("Dummy Page 2")
    }
}

struct DummyPage3View: View {
    var body: some View {
        // Your content for the third dummy page
        Text("Dummy Page 3")
    }
}
