# FlipAnimationView

![macOS iOS](https://img.shields.io/badge/platform-iOS_macOS-lightgrey)
![iOS](https://img.shields.io/badge/iOS-v14_orLater-blue)
![macOS](https://img.shields.io/badge/macOS-Big_Sur_orLater-blue)
![SPM is supported](https://img.shields.io/badge/SPM-Supported-orange)
![license](https://img.shields.io/badge/license-MIT-lightgrey)

<!--
comment
-->

## Feature

Flip animation for showing numbers


## in 30sec
![in30Sec](https://user-images.githubusercontent.com/6419800/142805791-f1b32079-00c9-48fd-9a88-a431dbdbb69d.gif)
## in 30sec

## Code Example
```
//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/20
//  © 2021  SmallDeskSoftware
//

import FlipAnimationView
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: FlipViewModel = FlipViewModel(0, range: 0...6)
    @StateObject var twoDigitsViewModel: FlipViewModel = FlipViewModel(0, range: 0...21)
    @StateObject var clockViewModel: ClockViewModel = ClockViewModel()
    var body: some View {
        VStack {
            SingleFlipView(viewModel.value.firstDigit, viewModel.prevIndex(viewModel.value).firstDigit, viewModel, duration: 0.3)
                .onTapGesture {
                    _ = viewModel.incrementIndex()
                }
            TwoDigitFlipView(twoDigitsViewModel, duration: 1.0)
                .onTapGesture {
                    _ = twoDigitsViewModel.incrementIndex()
                }
            DigitalClockView(clockViewModel)
        }
        .padding()
    }
}
```


## Installation
Swift Package Manager: https://github.com/tyagishi/FlipAnimationView

## Requirements
none

## Note
comments/feedback are really appreciated.
