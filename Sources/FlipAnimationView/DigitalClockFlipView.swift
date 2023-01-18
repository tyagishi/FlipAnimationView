//
//  DigitalClockFlipView.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/21
//  © 2021  SmallDeskSoftware
//

import Combine
import SwiftUI

public class ClockViewModel: FlipViewSource {
    var cancellable: AnyCancellable? = nil

    public init() {
        super.init(Int(Date().timeIntervalSinceReferenceDate))
        setupTimer()
    }
    
    func setupTimer() {
        self.cancellable = Timer.TimerPublisher.init(interval: 1.0, tolerance: 0.3, runLoop: .main, mode: .common, options: nil)
            .autoconnect()
            .sink { newValue in
                let now = Int(Date().timeIntervalSinceReferenceDate)
                if self.value != now { self.value = now }
            }
    }
    
    var now: Date { Date(timeIntervalSinceReferenceDate: TimeInterval(self.value)) }
    var last: Date { Date(timeIntervalSinceReferenceDate: TimeInterval(self.value - 1)) }
    
    var hourDigit: Int { Calendar.current.component(.hour, from: self.now) }
    var lastHourDigit: Int { Calendar.current.component(.hour, from: self.last) }

    var minuteDigit: Int { Calendar.current.component(.minute, from: self.now) }
    var lastMinuteDigit: Int { Calendar.current.component(.minute, from: self.last) }

    var secondDigit: Int { Calendar.current.component(.second, from: self.now) }
    var lastSecondDigit: Int { Calendar.current.component(.second, from: self.last) }
}

public struct DigitalClockView: View {
    @ObservedObject var viewModel: ClockViewModel

    public init(_ viewModel: ClockViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        HStack(spacing: 5) {
            HStack(spacing: 1) {
                SingleFlipView(viewModel.hourDigit.secondDigit, viewModel.lastHourDigit.secondDigit, viewModel, duration: 0.6)
                SingleFlipView(viewModel.hourDigit.firstDigit, viewModel.lastHourDigit.firstDigit, viewModel, duration: 0.6)
            }
            HStack(spacing: 1) {
                SingleFlipView(viewModel.minuteDigit.secondDigit, viewModel.lastMinuteDigit.secondDigit, viewModel, duration: 0.6)
                SingleFlipView(viewModel.minuteDigit.firstDigit, viewModel.lastMinuteDigit.firstDigit, viewModel, duration: 0.6)
            }
            HStack(spacing: 1) {
                SingleFlipView(viewModel.secondDigit.secondDigit, viewModel.lastSecondDigit.secondDigit, viewModel, duration: 0.6)
                SingleFlipView(viewModel.secondDigit.firstDigit, viewModel.lastSecondDigit.firstDigit, viewModel, duration: 0.6)
            }

        }
        
    }
    
}
