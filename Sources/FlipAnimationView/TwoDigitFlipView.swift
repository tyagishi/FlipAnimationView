//
//  TwoDigitFlipView.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/21
//  © 2021  SmallDeskSoftware
//

import SwiftUI

public struct TwoDigitFlipView<T: FlipViewSourceProtocol & ObservableObject>: View {
    @ObservedObject var viewModel: T
    let animationDuration: Double

    public init(_ viewModel: T, duration: Double = 0.3) {
        self.viewModel = viewModel
        self.animationDuration = duration
    }

    public var body: some View {
        HStack(spacing: 1) {
            SingleFlipView(viewModel.value.digit(at: 1), viewModel.prevIndex(viewModel.value).digit(at: 1), viewModel, duration: animationDuration)
            SingleFlipView(viewModel.value.digit(at: 0), viewModel.prevIndex(viewModel.value).digit(at: 0), viewModel, duration: animationDuration)
        }
    }
}
