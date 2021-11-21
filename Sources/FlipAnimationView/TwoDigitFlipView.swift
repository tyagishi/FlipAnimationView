//
//  TwoDigitFlipView.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/21
//  © 2021  SmallDeskSoftware
//

import SwiftUI



public struct TwoDigitFlipView: View {
    @ObservedObject var viewModel: FlipViewModel
    let animationDuration: Double

    public init(_ viewModel: FlipViewModel, duration: Double = 0.3) {
        self.viewModel = viewModel
        self.animationDuration = duration
    }

    public var body: some View {
        HStack(spacing: 1) {
            SingleFlipView(viewModel.value.secondDigit, viewModel.prevIndex(viewModel.value).secondDigit, viewModel, duration: animationDuration)
            SingleFlipView(viewModel.value.firstDigit, viewModel.prevIndex(viewModel.value).firstDigit, viewModel, duration: animationDuration)
        }
    }
}
