//
//  TwoDigitFlipView.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/21
//  © 2021  SmallDeskSoftware
//

import SwiftUI

public class FlipViewModel: FlipViewSource {
    let range: ClosedRange<Int>
    
    public init(_ initial: Int, range: ClosedRange<Int> = 0...9) {
        self.range = range
        super.init(initial)
    }
    
    public func incrementIndex() -> Bool {
        let index = value + 1
        let overflow = index > range.upperBound
        self.value = overflow ? range.lowerBound : index
        return overflow
    }

    func prevIndex(_ current:Int) -> Int {
        let prev = current - 1
        return prev < range.lowerBound ? range.upperBound : prev
    }
    func nextIndex(_ current:Int) -> Int {
        let next = current + 1
        return next > range.upperBound ? range.lowerBound : next
    }
}

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
