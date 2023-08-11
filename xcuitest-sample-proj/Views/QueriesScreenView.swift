//
//  QueriesScreenView.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 10.08.23.
//

import SwiftUI

struct QueriesScreenView: View {
    @State private var updateableTextValue: String = "FirstStackText1"
    @State private var isButtonVisible = true
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("FirstStackText")
                    .accessibilityIdentifier("FirstStackText")
                Text(updateableTextValue)
                    .accessibilityIdentifier("FirstStackText")
                    .onTapGesture {
                        // Change the text value when tapped
                        updateableTextValue = "Tapped"
                    }
                LazyVStack {
                    Text("FirstStackText3")
                        .accessibilityIdentifier("FirstStackText")
                    Text("FirstStackText4")
                        .accessibilityIdentifier("FirstStackText")
                    Text("FirstStackText5")
                        .accessibilityIdentifier("FirstStackText")
                    LazyVStack {
                        Text("FirstStackText6")
                            .accessibilityIdentifier("FirstStackText")
                    }
                }
                .accessibilityIdentifier("FirstStackFirstChildStack")
                .border(.green)
                .padding()
            }
            .border(.black)
            .accessibilityIdentifier("FirstStack")
            .padding()
            
            LazyVStack {
                if isButtonVisible {
                    Button(action: {
                        isButtonVisible = false
                    }) {
                        LazyVStack{
                            Image(systemName: "heart.fill")
                                .accessibilityIdentifier("TestImage")
                        }
                    }
                    .accessibilityIdentifier("SecondStackButton")
                }
            }
            .accessibilityIdentifier("SecondStack")
            
        }
        .accessibilityIdentifier("QueriesScrollView")
        
    }
}

struct AccessibilityGroup<Content: View>: View {
    let identifier: String
    let content: Content
    
    init(identifier: String, @ViewBuilder content: () -> Content) {
        self.identifier = identifier
        self.content = content()
    }
    
    var body: some View {
        content
            .accessibility(identifier: identifier)
    }
}
