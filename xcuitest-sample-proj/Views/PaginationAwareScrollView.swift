//
//  PaginationAwareScrollView.swift
//  xcuitest-sample-proj
//
//  Created by Nikola Shabanov on 20.07.23.
//

import SwiftUI

struct PaginationAwareScrollView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollView(.horizontal) {
            ScrollViewReader { proxy in
                HStack {
                    content
                }
                .onChange(of: currentIndex) { newIndex in
                    withAnimation {
                        proxy.scrollTo(newIndex)
                    }
                }
            }
        }
    }

    private var currentIndex: Int {
        return Int((CGFloat(UIScreen.main.bounds.midX) + contentOffset) / itemWidth)
    }

    private var itemWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    private var contentOffset: CGFloat {
        UIScrollView().contentOffset.x
    }
}
