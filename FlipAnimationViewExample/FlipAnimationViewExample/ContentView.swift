//
//  ContentView.swift
//  FlipAnimationViewExample
//
//  Created by Tomoaki Yagishita on 2025/06/04.
//

import SwiftUI
import FlipAnimationView

struct ContentView: View {
    @StateObject var viewModel: FlipViewModel = FlipViewModel(0, range: 0...6)
    @StateObject var twoDigitsViewModel: FlipViewModel = FlipViewModel(0, range: 0...21)
    @StateObject var multiDigitsViewModel: FlipViewModel = FlipViewModel(0, range: 0...10_100)
    @StateObject var clockViewModel: ClockViewModel = ClockViewModel()
    var body: some View {
        VStack {
            SingleFlipView(viewModel.value.firstDigit, viewModel.prevIndex(viewModel.value).firstDigit, viewModel, duration: 0.3)
                .onTapGesture {
                    _ = viewModel.incrementIndex()
                }
            MultiDigitFlipView(twoDigitsViewModel, digitNum: 2, duration: 0.2)
                .onTapGesture {
                    _ = twoDigitsViewModel.incrementIndex()
                }
            TwoDigitFlipView(twoDigitsViewModel, duration: 1.0)
                .onTapGesture {
                    _ = twoDigitsViewModel.incrementIndex()
                }
            
            MultiDigitFlipView(multiDigitsViewModel, digitNum: 5, duration: 0.2)
                .onTapGesture {
                    _ = multiDigitsViewModel.incrementIndex()
                }
            DigitalClockView(clockViewModel)
        }
        .padding()
    }
}
