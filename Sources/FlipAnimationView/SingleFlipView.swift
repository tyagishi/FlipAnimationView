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

    @State private var initialAnim: Double = 0.5

    public init(_ nextIndex: Int,_ fromIndex: Int,_ viewModel: FlipViewSource, duration: Double = 0.3) {
        self.nextIndex = nextIndex
        self.fromIndex = fromIndex
        self.viewModel = viewModel
        self.animationDuration = duration
    }

    @State private var upAnim = false
    @State private var downAnim = false

    public var body: some View {
        //let _ = { print("SingleFlipView"); Self._printChanges() }() // need macOS 12 or above
        VStack {
            VStack(spacing:0) {
                ZStack {
                    Image("L\(nextIndex)_01", bundle: .module).resizable().scaledToFit()
                    Image("L\(fromIndex)_01", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: upAnim ? -89.99 : 0),
                                          axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.05)
                }
                ZStack {
                    Image("L\(fromIndex)_02", bundle: .module).resizable().scaledToFit()
                    Image("L\(nextIndex)_02", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: downAnim ? 0 : 89.99),
                                          axis: (x:1,y:0,z:0), anchor: .top, anchorZ: 0, perspective: 0.05)
                        .zIndex(1.0)
                }
            }
            .onReceive(viewModel.$value) { _ in
                upAnim = false
                downAnim = false
                withAnimation(Animation.linear(duration: animationDuration/2.0)){
                    upAnim = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration/2.0+initialAnim) {
                    withAnimation(Animation.linear(duration: animationDuration/2.0)){
                        downAnim = true
                        initialAnim = 0.0
                    }
                }
            }
        }
    }
}
