//
//  MultiDigitFlipView.swift
//  FlipAnimationView
//
//  Created by Tomoaki Yagishita on 2025/06/05.
//

import Foundation
import SwiftUI

public struct MultiDigitFlipView<T: FlipViewSourceProtocol & ObservableObject>: View {
    @ObservedObject var viewModel: T
    let digitNum: Int
    let animationDuration: Double

    public init(_ viewModel: T, digitNum: Int, duration: Double = 0.3) {
        self.viewModel = viewModel
        self.digitNum = digitNum
        self.animationDuration = duration
    }

    public var body: some View {
        HStack(spacing: 1) {
            ForEach((0..<digitNum).reversed(), id: \.self) { digit in
                SingleFlipView(viewModel.value.digit(at: digit), viewModel.prevIndex(viewModel.value).digit(at: digit), viewModel, duration: animationDuration)
            }
        }
    }
}
