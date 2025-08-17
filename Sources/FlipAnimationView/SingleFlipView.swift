//
//  SingleFlipView.swift
//
//  Created by : Tomoaki Yagishita on 2021/11/21
//  © 2021  SmallDeskSoftware
//

import SwiftUI
import OSLog

extension OSLog {
    //static let logger = Logger(subsystem: "com.smalldesksoftware", category: "FlipAnimationView")
    static let logger = Logger(.disabled)
}


extension Int {
    public func digit(at: Int) -> Int {
//        guard self > Int(pow(10.0, Double(at))) else { return 0 }
        // get 1 from 4123 (at: 2)
        let remain = self % Int(pow(10.0, Double(at+1)))
        let num = Int(remain) / Int(pow(10.0, Double(at)))
        return num
    }

    public var firstDigit: Int {
        let reminder = self % 10
        return reminder
    }
    public var secondDigit: Int {
        let reminder = Int(Double(self) / 10.0) % 10
        return reminder
    }
}

public protocol FlipViewSourceProtocol {
    var value:Int { get set }
    var range: ClosedRange<Int> { get }
    func prevIndex(_ current:Int) -> Int
    func nextIndex(_ current:Int) -> Int
    
    func digit(at: Int) -> Int
}

public class FlipViewSource: ObservableObject, FlipViewSourceProtocol {
    @Published public var value:Int
    public let range: ClosedRange<Int>

    public init(_ initial: Int, range: ClosedRange<Int>) {
        self.value = initial
        self.range = range
    }
}

extension FlipViewSourceProtocol {
    public func prevIndex(_ current:Int) -> Int {
        let prev = current - 1
        return prev < range.lowerBound ? range.upperBound : prev
    }
    public func nextIndex(_ current:Int) -> Int {
        let next = current + 1
        return next > range.upperBound ? range.lowerBound : next
    }
    public func digit(at: Int) -> Int { fatalError("not implemented") }
}


public class FlipViewModel: FlipViewSourceProtocol, ObservableObject {
    @Published public var value: Int
    public let range: ClosedRange<Int>
    
    public init(_ initial: Int, range: ClosedRange<Int> = 0...9) {
        self.value = initial
        self.range = range
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
    public func nextIndex(_ current:Int) -> Int {
        let next = current + 1
        return next > range.upperBound ? range.lowerBound : next
    }
}

public struct SingleFlipView<T: FlipViewSourceProtocol & ObservableObject>: View {
    @ObservedObject var viewModel: T

    @State private var nextIndex: Int
    @State private var fromIndex: Int
    let animationDuration: Double

    @State private var initialAnim: Double = 0.5

    public init(_ nextIndex: Int,_ fromIndex: Int,_ viewModel: T, duration: Double = 0.3) {
        self.nextIndex = nextIndex
        self.fromIndex = fromIndex
        self.viewModel = viewModel
        self.animationDuration = duration
        OSLog.logger.debug(">>> SingleFlipView init next: \(nextIndex) from: \(fromIndex)")
    }
    public init(_ viewModel: T, duration: Double = 0.3) {
        self.nextIndex = viewModel.value
        self.fromIndex = viewModel.prevIndex(viewModel.value)
        self.viewModel = viewModel
        self.animationDuration = duration
        OSLog.logger.debug(">>> SingleFlipView init: \(viewModel.value), \(viewModel.prevIndex(viewModel.value))")
    }

    @State private var upAnim = false
    @State private var downAnim = false

    public var body: some View {
        let _ = { OSLog.logger.debug("SingleFlipView from: \(fromIndex) next: \(nextIndex)')"); }// Self._printChanges() }() // need macOS 12 or above
        VStack {
            VStack(spacing:0) {
                ZStack {
                    Image("L\(nextIndex)_01", bundle: .module).resizable().scaledToFit()
                    Image("L\(fromIndex)_01", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: (upAnim && (nextIndex != fromIndex)) ? -89.99 : 0),
                                          axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.05)
                        .opacity((upAnim && downAnim) ? 0.0 : 1.0 )
                }
                ZStack {
                    Image("L\(fromIndex)_02", bundle: .module).resizable().scaledToFit()
                        .opacity((upAnim && downAnim) ? 0.0 : 1.0 )
                    Image("L\(nextIndex)_02", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: ( downAnim && (nextIndex != fromIndex)) ? 0 : 89.99),
                                          axis: (x:1,y:0,z:0), anchor: .top, anchorZ: 0, perspective: 0.05)
                        .zIndex(1.0)
                }
            }
            .onChange(of: viewModel.value, perform: { _ in
                OSLog.logger.debug("viewModel.value changed to \(viewModel.value) with from: \(fromIndex) next: \(nextIndex)")
                fromIndex = viewModel.prevIndex(viewModel.value)
                nextIndex = viewModel.value
                animate()
            })
        }
    }
    
    func animate() {
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
