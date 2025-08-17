//
//  SwiftUIView.swift
//  FlipAnimationView
//
//  Created by Tomoaki Yagishita on 2025/08/17.
//

import SwiftUI

public struct FlipNumberPair: NumberForFlip {
    public var current: Int
    public var next: Int
    public init(_ current: Int,_ next: Int) {
        self.current = current
        self.next = next
    }
    // note: index starts from 0 and from right
    // i.e. for 12345,   index = 0, means 5, index=3 means 2
    public func flipNumberPair(at index: Int) -> FlipNumberPair {
        return FlipNumberPair(current.digit(at: index), next.digit(at: index))
    }
    public func adjust(_ diff: Int) -> FlipNumberPair {
        return FlipNumberPair(self.current + diff, self.next + diff)
    }
}

extension FlipNumberPair: CustomDebugStringConvertible {
    public var debugDescription: String {
        "current: \(current) next: \(next)"
    }
}

public protocol NumberForFlip: Equatable {
    var current: Int { get }
    var next: Int { get }
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
                    Image("L\(displayDigit.next)_01", bundle: .module).resizable().scaledToFit()
                    Image("L\(displayDigit.current)_01", bundle: .module).resizable().scaledToFit()
                        .rotation3DEffect(Angle(degrees: upAnim  ? -89.99 : 0),
                                          axis: (x:1,y:0,z:0), anchor: .bottom, anchorZ: 0, perspective: 0.05)
                        .opacity((upAnim && downAnim) ? 0.0 : 1.0 )
                }
                ZStack {
                    Image("L\(displayDigit.current)_02", bundle: .module).resizable().scaledToFit()
                    Image("L\(displayDigit.next)_02", bundle: .module).resizable().scaledToFit()
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
                if displayDigit.current == displayDigit.next { return }
                animate()
            })
            // for macOS 14 or above
//            .onChange(of: currentNextNumber, initial: true, { _, new in
//                animate()
//            })
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
            }
        }
    }
}

