//
//  CarouselItemView.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 20.07.23.
//

import SwiftUI

struct CarouselItemView: View {
    let item: Int

    var body: some View {
        Text("Item \(item)")
            .frame(width: 150, height: 150)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .accessibilityIdentifier("carousel_item\(item)")
    }
}
