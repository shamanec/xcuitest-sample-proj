//
//  QueriesScreenView.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 10.08.23.
//

import SwiftUI

struct QueriesScreenView: View {
    var body: some View {
        ScrollView {
            AccessibilityGroup(identifier: "first-group") {
                Text("Descendant 1")
                    .accessibilityIdentifier("first-stack-text")
                Text("Descendant 2")
                    .accessibilityIdentifier("first-stack-text")
                AccessibilityGroup(identifier: "first-group-child") {
                    Text("Descendant 3")
                        .accessibilityIdentifier("first-stack-text")
                    Text("Descendant 4")
                        .accessibilityIdentifier("first-stack-text")
                    AccessibilityGroup(identifier: "first-group-child-child") {
                        Text("Descendant 5")
                            .accessibilityIdentifier("first-stack-text")
                    }
                    .border(.green)
                    .padding()
                }
                .border(.blue)
                .padding()
            }
            .border(.black)
            
            Spacer()
            
            AccessibilityGroup(identifier: "second-group") {
                Text("SECOND STACK")
            }
            .border(.black)
        }
        .accessibilityIdentifier("queries-view")
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
