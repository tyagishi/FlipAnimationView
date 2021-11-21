//
//  SingleFlipView.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/21
//  © 2021  SmallDeskSoftware
//

import SwiftUI

extension Int {
    public var firstDigit: Int {
        let reminder = self % 10
        return reminder
    }
    public var secondDigit: Int {
        let reminder = Int(Double(self) / 10.0) % 10
        return reminder
    }
}

public class FlipViewSource:ObservableObject {
    @Published public var value:Int
    public init(_ initial: Int) {
        self.value = initial
    }
}

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

    public func prevIndex(_ current:Int) -> Int {
        let prev = current - 1
        return prev < range.lowerBound ? range.upperBound : prev
    }
    func nextIndex(_ current:Int) -> Int {
        let next = current + 1
        return next > range.upperBound ? range.lowerBound : next
    }
}

public struct SingleFlipView: View {
    @ObservedObject var viewModel: FlipViewSource

    let nextIndex: Int
    let fromIndex: Int
    let animationDuration: Double

    public init(_ nextIndex: Int,_ fromIndex: Int,_ viewModel: FlipViewSource, duration: Double = 0.3) {
        self.nextIndex = nextIndex
        self.fromIndex = fromIndex
        self.viewModel = viewModel
        self.animationDuration = duration
    }

    @State private var upAnim = false
    @State private var downAnim = false

    var upperCurrentIndex: Int {
        if !upAnim {
            return nextIndex
        }
        return fromIndex
    }
    var lowerCurrentIndex: Int {
        if upAnim || downAnim {
            return fromIndex
        }
        return nextIndex
    }
    
    public var body: some View {
        VStack {
            VStack(spacing:0) {
                ZStack {
                    Image("\(nextIndex)up", bundle: Bundle.module).resizable().scaledToFit()
                    Image("\(upperCurrentIndex)up").resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: (upAnim && (nextIndex != fromIndex))  ? -89.99 : 0),
                                          axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.1)
                }
                ZStack {
                    Image("\(lowerCurrentIndex)down").resizable().scaledToFit()
                    Image("\(nextIndex)down").resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: (downAnim && (nextIndex != fromIndex)) ? 0 : 89.99),
                                      axis: (x:1,y:0,z:0), anchor: .top, anchorZ: 0, perspective: 0.1)
                }
            }
            .onReceive(viewModel.$value) { _ in
                withAnimation(Animation.linear(duration: animationDuration)){
                    upAnim = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration) {
                    upAnim = false
                    withAnimation(Animation.linear(duration: animationDuration)) {
                        downAnim = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration) {
                        downAnim = false
                    }
                }
            }
        }
    }
}
