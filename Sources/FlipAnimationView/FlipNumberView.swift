//
//  SwiftUIView.swift
//  FlipAnimationView
//
//  Created by Tomoaki Yagishita on 2025/08/17.
//

import SwiftUI

public struct FlipNumberPair: NumberForFlip {
    public var prev: Int
    public var current: Int
    public init(_ prev: Int,_ current: Int) {
        self.prev = prev
        self.current = current
    }
    // note: index starts from 0 and from right
    // i.e. for 12345,   index = 0, means 5, index=3 means 2
    public func flipNumberPair(at index: Int) -> FlipNumberPair {
        return FlipNumberPair(prev.digit(at: index), current.digit(at: index))
    }
    public func adjust(_ diff: Int) -> FlipNumberPair {
        return FlipNumberPair(self.prev + diff, self.current + diff)
    }
}

extension FlipNumberPair: CustomDebugStringConvertible {
    public var debugDescription: String {
        "current: \(prev) next: \(current)"
    }
}

public protocol NumberForFlip: Equatable {
    var prev: Int { get }
    var current: Int { get }
    func flipNumberPair(at: Int) -> Self
}

public struct FlipNumberView<T>: View where T: NumberForFlip {
    @Binding var currentNextNumber: T
    let digitNum: Int
    let animationDuration: Double
    
    public init(currentNextNumber: Binding<T>, digitNum: Int = 1, animationDuration: Double = 0.3) {
        self._currentNextNumber = currentNextNumber
        self.digitNum = digitNum
        self.animationDuration = animationDuration
    }
    public var body: some View {
        HStack(spacing: 1) {
            ForEach((0..<digitNum).reversed(), id: \.self) { digit in
                SingleFlipNumberView(currentNextNumber: $currentNextNumber, digitIndex: digit, animationDuration: animationDuration)
            }
        }
    }
}

public struct SingleFlipNumberView<T>: View where T: NumberForFlip{
    @Binding var currentNextNumber: T

    let digitIndex: Int
    
    @State private var upAnim = false
    @State private var downAnim = false
    let animationDuration: Double
    
    public init(currentNextNumber: Binding<T>, digitIndex: Int, animationDuration: Double = 0.3) {
        self._currentNextNumber = currentNextNumber
        self.digitIndex = digitIndex
        self.animationDuration = animationDuration
    }

    public var body: some View {
        VStack {
            VStack(spacing:0) {
                let displayDigit = currentNextNumber.flipNumberPair(at: digitIndex)
                ZStack {
                    Image("L\(displayDigit.current)_01", bundle: .module).resizable().scaledToFit()
                    Image("L\(displayDigit.prev)_01", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: upAnim  ? -89.99 : 0),
                                          axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.05)
                        .opacity((upAnim && downAnim) ? 0.0 : 1.0 )
                }
                ZStack {
                    Image("L\(displayDigit.prev)_02", bundle: .module).resizable().scaledToFit()
                    Image("L\(displayDigit.current)_02", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: downAnim ? 0 : 89.99),
                                          axis: (x:1,y:0,z:0), anchor: .top, anchorZ: 0, perspective: 0.05)
                        .zIndex(1.0)
                }
            }
            .onAppear {
                animate()
            }
            .onChange(of: currentNextNumber, perform: { new in
                let displayDigit = currentNextNumber.flipNumberPair(at: digitIndex)
                if displayDigit.prev == displayDigit.current { return }
                animate()
            })
            // for macOS 14 or above
//            .onChange(of: currentNextNumber, initial: true, { _, new in
//                animate()
//            })
        }
    }
    func animate() {
        let displayDigit = currentNextNumber.flipNumberPair(at: digitIndex)
        if displayDigit.prev == displayDigit.current { upAnim = true; downAnim = true; return }
        upAnim = false
        downAnim = false
        withAnimation(Animation.linear(duration: animationDuration/2.0)){
            upAnim = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration/2.0) {
            withAnimation(Animation.linear(duration: animationDuration/2.0)){
                downAnim = true
            }
        }
    }
}

enum NumberAnimPhase {
    case none
    case upper
    case bottom
}

public struct SingleFlipNumberView2: View {
    let displayNumber: Int
    @State var prevNumber: Int?
    let digitIndex: Int
    @State private var upAnim = false
    @State private var downAnim = false
    let animationDuration: Double

    public init(_ displayNumber: Int, at digitIndex: Int, animationDuration: Double = 0.3) {
        self.prevNumber = nil
        self.displayNumber = displayNumber
        self.digitIndex = digitIndex
        self.animationDuration = animationDuration
    }
    public var body: some View {
        VStack {
            VStack(spacing:0) {
                let displayDigit = displayNumber.digit(at: digitIndex)
                ZStack {
                    Image("L\(displayDigit)_01", bundle: .module).resizable().scaledToFit()
                    if let prevNumber = prevNumber {
                        Image("L\(prevNumber)_01", bundle: .module).resizable().scaledToFit()
                            .rotation3DEffect(Angle(degrees: upAnim  ? -89.99 : 0),
                                              axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.05)
//                            .opacity((upAnim && downAnim) ? 0.0 : 1.0 )
                    }
                }
                ZStack {
                    if let prevNumber = prevNumber {
                        Image("L\(prevNumber)_02", bundle: .module).resizable().scaledToFit()
                    }
                    Image("L\(displayDigit)_02", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: downAnim ? 0 : 89.99),
                                          axis: (x:1,y:0,z:0), anchor: .top, anchorZ: 0, perspective: 0.05)
                        .zIndex(1.0)
                }
            }
            .onAppear {
                if prevNumber==nil { upAnim = true; downAnim = true; return }
                animate()
            }
            .onChange(of: displayNumber, perform: { new in
                prevNumber = displayNumber
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
        DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration/2.0) {
            withAnimation(Animation.linear(duration: animationDuration/2.0)){
                downAnim = true
                prevNumber = nil
            }
        }
    }
}

//
//
//public struct SingleFlipNumberView2<T>: View where T: NumberForFlip{
//    let displayNumber: Int
//
//    let digitIndex: Int
//    
//    @State private var upAnim = false
//    @State private var downAnim = false
//    let animationDuration: Double
//    
//    public init(_ displayNumber: Int, digitIndex: Int, animationDuration: Double = 0.3) {
//        self.displayNumber = displayNumber
//        self.digitIndex = digitIndex
//        self.animationDuration = animationDuration
//    }
//
//    public var body: some View {
//        VStack {
//            VStack(spacing:0) {
//                let displayDigit = currentNextNumber.flipNumberPair(at: digitIndex)
//                ZStack {
//                    Image("L\(displayDigit.current)_01", bundle: .module).resizable().scaledToFit()
//                    Image("L\(displayDigit.prev)_01", bundle: .module).resizable().scaledToFit()
//                        .rotation3DEffect(Angle(degrees: upAnim  ? -89.99 : 0),
//                                          axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.05)
//                        .opacity((upAnim && downAnim) ? 0.0 : 1.0 )
//                }
//                ZStack {
//                    Image("L\(displayDigit.prev)_02", bundle: .module).resizable().scaledToFit()
//                    Image("L\(displayDigit.current)_02", bundle: .module).resizable().scaledToFit()
//                        .rotation3DEffect(Angle(degrees: downAnim ? 0 : 89.99),
//                                          axis: (x:1,y:0,z:0), anchor: .top, anchorZ: 0, perspective: 0.05)
//                        .zIndex(1.0)
//                }
//            }
//            .onAppear {
//                animate()
//            }
//            .onChange(of: displayNumber, { oldValue, newValue in
////                <#code#>
////            })
////            .onChange(of: displayNumber, perform: { new in
////                let displayDigit = currentNextNumber.flipNumberPair(at: digitIndex)
////                if displayDigit.prev == displayDigit.current { return }
//                animate()
//            })
//            // for macOS 14 or above
////            .onChange(of: currentNextNumber, initial: true, { _, new in
////                animate()
////            })
//        }
//    }
//    func animate() {
////        let displayDigit = currentNextNumber.flipNumberPair(at: digitIndex)
////        if displayDigit.prev == displayDigit.current { upAnim = true; downAnim = true; return }
////        upAnim = false
////        downAnim = false
////        withAnimation(Animation.linear(duration: animationDuration/2.0)){
////            upAnim = true
////        }
////        DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration/2.0) {
////            withAnimation(Animation.linear(duration: animationDuration/2.0)){
////                downAnim = true
////            }
////        }
//    }
//}

